locals {
  combined_tags = merge(var.tags, {
    managed_by = "terraform"
  })
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}


## General

resource "random_string" "project_suffix" {
  length  = 6
  special = false
  upper   = false
}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.name}-${random_string.project_suffix.result}"
  location = var.location
  tags     = local.combined_tags
}

## Networking

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name}-${random_string.project_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = local.combined_tags
}

resource "azurerm_subnet" "public" {
  name                 = "snet-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "snet-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "management" {
  name                 = "snet-mgmt"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

## Compute

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.name}-${random_string.project_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

  tags = local.combined_tags
}
resource "azurerm_public_ip" "vm_public_ip" {
  name                = "pip-${var.name}-${random_string.project_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags               = local.combined_tags
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
  upper   = true
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${var.name}-${random_string.project_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.instance_type
  admin_username      = "adminuser"
  admin_password      = random_password.admin_password.result
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  user_data = base64encode(file("${path.module}/../../../deploy/simple-nginx/install_nginx.sh"))

  tags = local.combined_tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-${var.name}-${random_string.project_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowAllInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.combined_tags
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

## Storage

resource "azurerm_storage_account" "storage" {
  name                     = "bucket${var.name}${random_string.project_suffix.result}"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.combined_tags
}

resource "azurerm_storage_container" "container" {
  name                  = "employee-data"
  container_access_type = "container"
  storage_account_id    = azurerm_storage_account.storage.id
}

resource "azurerm_role_assignment" "vm_storage_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

resource "azurerm_storage_blob" "sensitive_data" {
  name                   = "users-data.csv"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/../../../deploy/sensitive-data/users-data.csv"
}

# Identity

resource "azurerm_role_assignment" "vm_identity_access" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

# AKS

resource "azurerm_container_registry" "acr" {
  name                = "acr${var.name}${random_string.project_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                = "Standard"
  admin_enabled      = true
  tags               = local.combined_tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.name}-${random_string.project_suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-${var.name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.combined_tags
}

# Grant AKS access to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
