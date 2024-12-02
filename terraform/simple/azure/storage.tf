#
# Storage
#

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