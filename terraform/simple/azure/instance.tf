#
# Compute
#

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${module.lab.name}-${module.lab.short_id}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }

  tags = module.lab.tags
}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.vm_nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                = "pip-${module.lab.name}-${module.lab.short_id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.lab.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${module.lab.name}-${module.lab.short_id}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = var.instance_type
  admin_username      = var.admin_username
  admin_password      = module.lab.password

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key_path)
  }

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

  user_data = base64encode(templatefile("${path.module}/files/setup.sh", { admin_username = var.admin_username }))

  tags = module.lab.tags
}

