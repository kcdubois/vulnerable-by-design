#
# VM Identity
#

resource "azurerm_role_assignment" "vm_identity_access" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}
# Grant high-privileged access to the VM's managed identity
resource "azurerm_role_assignment" "vm_owner_access" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner" 
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

# Grant data access permissions
resource "azurerm_role_assignment" "vm_data_access" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

resource "azurerm_role_assignment" "vm_key_vault_access" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

# Create Azure AD application for service principal
resource "azuread_application" "sp" {
  display_name = "${var.name}-api-client" 
}

# Create service principal
resource "azuread_service_principal" "sp" {
  client_id = azuread_application.sp.client_id
}

resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = azuread_service_principal.sp.id

}

# Assign Contributor role to service principal
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}

