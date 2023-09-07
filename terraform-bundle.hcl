terraform {
  # Version of Terraform to include in the bundle. An exact version number
  # is required.
  version = "1.5.6"
}

# Define which provider plugins are to be included
providers {
  azurerm = {
    versions = ["3.69.0"]
    source = "hashicorp/azurerm"
  }
  random = {
    versions = ["3.5.1"]
    source = "hashicorp/random"
  }
  time = {
    versions = ["0.9.1"]
    source = "hashicorp/time"
  }
  azapi = {
   versions = ["1.9.0"]
   source = "azure/azapi"
  }

}

