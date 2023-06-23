# Variables

variable "resource_group_name" {
  type    = string
  default = "cloud_newest"
}

variable "storage_account_name" {
  type    = string
  default = "cloudneweststorage"
}

variable "azure_dns_zone" {
  type    = string
  default = "pitels-cloud.xyz"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "cdn_profile_name" {
  type    = string
  default = "cloudcdnprofile"
}

variable "cdn_endpoint" {
  type    = string
  default = "cloudcdnendpoint"
}

variable "origin_server" {
  type    = string
  default = "53023cdntest"
}

variable "hostname" {
  type    = string
  default = "cloudneweststorage.z13.web.core.windows.net"
}

variable "azurerm_dns_cname" {
  type    = string
  default = "www.pitels-cloud.xyz"  
}

