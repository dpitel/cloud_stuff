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
# Resources
#

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#
# Create Storage Account
#
resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
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
  content_type           = "text/html"
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

#
# Adding Azure CDN stuff to my site/tenant/setup
#

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = var.cdn_profile_name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_Verizon"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = var.cdn_endpoint
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  origin {
    name      = var.origin_server
    host_name = var.hostname
  }
}

resource "azurerm_dns_zone" "zone" {
  name                = var.azure_dns_zone
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_dns_cname_record" "cname_record" {
  name                  = var.azurerm_dns_cname
  zone_name             = var.azure_dns_zone
  resource_group_name   = var.resource_group_name
  ttl                   = 300
  record                = "www" 
}

resource "azurerm_cdn_endpoint_custom_domain" "custom_domain" {
  name                = "customdomain"
  cdn_endpoint_id     = azurerm_cdn_endpoint.cdn_endpoint.id
  host_name           = var.azurerm_dns_cname
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
    tls_version      = "TLS12" 
  }  
}