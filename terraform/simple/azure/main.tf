module "lab" {
  source = "../../modules/lab"

  prefix = var.name
  tags   = var.tags
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${module.lab.name}-${module.lab.short_id}"
  location = var.location
  tags     = module.lab.tags
}
