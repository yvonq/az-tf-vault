terraform {
  backend "azurerm" {
    resource_group_name  = "yqs-rg"
    storage_account_name = "yqstfstate26284"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version         =   "~> 2.0"
    }
	azuread = {
      source  = "hashicorp/azuread"
      version         =   ">= 0.11"
    }
  }

}

# Provider Block

provider "azurerm" {
    
    features {}
}

provider "azuread" {
    
    alias           =   "ad"
}
#####
resource "azurerm_resource_group" "yqs-tf-demo-rg" {
  name     = "yqs-tf-demo"
  location = "francecentral"
}

resource "azurerm_virtual_network" "yqs-tf-demo-network" {
  name                = "${var.prefix}-tf-demo-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.yqs-tf-demo-rg.location
  resource_group_name = azurerm_resource_group.yqs-tf-demo-rg.name
}
resource "azurerm_private_dns_zone" "yqs-tf-demo-network" {
  name                = var.private_dns_zone
  resource_group_name         = azurerm_resource_group.yqs-tf-demo-rg.name
}