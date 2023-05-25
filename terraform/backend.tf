#terraform {
#    backend "azurerm" {
#        resource_group_name     = "tfstates"
#        storage_account_name    = "dimastore"
#        container_name          = "tfstatesdevops"
#        key                     = "tfstatesdevops.tfstate"
#    }
#}



terraform {
  backend "azurerm" {
    resource_group_name  = "tfstates"
    storage_account_name = "dimastore"
    container_name       = "tfstatesdevops"
    key                  = "tfstatesdevops.tfstate"
  }
}
