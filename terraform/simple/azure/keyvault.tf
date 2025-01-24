resource "azurerm_key_vault" "vault" {
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  name     = "kv-${module.lab.name}-${module.lab.short_id}"
  location = var.location

  enabled_for_disk_encryption = true
  enable_rbac_authorization   = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = module.lab.tags

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "example-secret"
  value        = "VerySecretValue123!"
  key_vault_id = azurerm_key_vault.vault.id

  depends_on = [azurerm_role_assignment.current_rbac_rg]
}
