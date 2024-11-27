terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }

    random = {
      source  = "hashicorp/random"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  use_cli = true
}
