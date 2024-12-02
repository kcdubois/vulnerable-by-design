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

