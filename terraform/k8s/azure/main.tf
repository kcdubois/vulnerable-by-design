module "lab" {
  source = "../../modules/lab"

  tags = var.tags
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${module.lab.full_name}-aks"
  location = var.location

  tags = module.lab.tags
}
