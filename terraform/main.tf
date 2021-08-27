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

