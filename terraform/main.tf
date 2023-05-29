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

#
# Create Storage Account
#
resource "azurerm_storage_account" "storage_account" {
  name                = "cloudneweststorage"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document = "index.html"
  }
}

#
# Add index.html to blob storage
#
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "test/html"
  source_content         = file("./website/index.html") #("$(path.module)/website/index.html")   
}

resource "azurerm_storage_blob" "my_pic" {
  name                   = "my_pic.jpg"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/jpg"
  source_content         = filebase64("./website/my_pic.jpg") #("$(path.module)/website/my_pic.jpg") 
}

resource "azurerm_storage_blob" "pex_2" {
  name                   = "pex_2.jpg"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "image/jpg"
  source_content         = filebase64("./website/pex_2.jpg") #("$(path.module)/website/pex_2.jpg")     
}

resource "azurerm_storage_blob" "newest" {
  name                   = "newest.css"
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/css"
  source_content         = file("./website/newest.css") #("$(path.module)/website/newest.css")
}
