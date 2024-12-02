#
# Compute
#

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