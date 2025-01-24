#
# VM Identity
#

resource "azurerm_role_assignment" "vm_rbac_rg" {
  # Lists of assignment 
  for_each = toset([
    "Contributor",
    "Storage Account Key Operator Service Role",
    "Key Vault Administrator",
    "Key Vault Crypto Officer"
  ])

  scope                = azurerm_resource_group.rg.id
  role_definition_name = each.value
  principal_id         = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

resource "azurerm_role_assignment" "current_rbac_rg" {
  # Adds the required permission to be able to make changes to created key vauls

  for_each = toset([
    "Key Vault Administrator",
    "Key Vault Purge Operator",
    "Key Vault Secrets Officer"
  ])

  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = each.value
}

# New IAM user

# Create Azure AD application for service principal
resource "azuread_application" "sp" {
  display_name = "${module.lab.name}-api-client"
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

