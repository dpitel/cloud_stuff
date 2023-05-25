#
# Providers
#

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.56.0"
    }
  }

  required_version = ">= 1.4.6"
}

provider "azurerm" {
  features {}
}

#
# Variables
#

#variable "resource_group_name" {
#  type    = string
#  default = "cloud_newest"
#}

#variable "location" {
#  type    = string
#  default = "eastus"
#}

#
# Resources
#

resource "azurerm_resource_group" "rg" {
  name     = "cloud_newest"
  location = "eastus"
}