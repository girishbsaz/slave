terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.59.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

module "Private_endpoints" {
  source              = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/privateendpoints/?ref=dev"
  resource_group_name = "rg-syn-prod-we-002"

  private_endpoints = {
    pe1 = {
      resource_name                 = "syn-cbudw-prod-001"         # Mysql Server name
      name                          = "pe-syn-cbudw-001" # Private Endpoint name <resource_name>-pe
      subnet_id                     = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/rg-network-shared-prod-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-001/subnets/snet-prod-we-001"
      subnet_name                   = "snet-prod-we-001"
      vnet_name                     = "vnet-prod-we-001"
      networking_resource_group     = "rg-network-shared-prod-001"
      group_ids                     = ["Sql"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = null
      dns_rg_name                   = null
      dns_zone_group_name           = null
      private_connection_address_id = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/Rg-syn-prod-we-002/providers/Microsoft.Synapse/workspaces/syn-cbudw-prod-001"
    }
    pe2 = {
      resource_name                 = "syn-cbudw-prod-001"         # Mysql Server name
      name                          = "pe-syn-cbudw-002" # Private Endpoint name <resource_name>-pe
      subnet_id                     = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/rg-network-shared-prod-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-001/subnets/snet-prod-we-001"
      subnet_name                   = "snet-prod-we-001"
      vnet_name                     = "vnet-prod-we-001"
      networking_resource_group     = "rg-network-shared-prod-001"
      group_ids                     = ["Dev"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = null
      dns_rg_name                   = null
      dns_zone_group_name           = null
      private_connection_address_id = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/Rg-syn-prod-we-002/providers/Microsoft.Synapse/workspaces/syn-cbudw-prod-001"
    }
    pe3 = {
      resource_name                 = "sysstorecbudwprod001"         # Mysql Server name
      name                          = "pe-synstore-cbudw-001" # Private Endpoint name <resource_name>-pe
      subnet_id                     = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/rg-network-shared-prod-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-001/subnets/snet-prod-we-001"
      subnet_name                   = "snet-prod-we-001"
      vnet_name                     = "vnet-prod-we-001"
      networking_resource_group     = "rg-network-shared-prod-001"
      group_ids                     = ["blob"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = null
      dns_rg_name                   = null
      dns_zone_group_name           = null
      private_connection_address_id = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/Rg-syn-prod-we-002/providers/Microsoft.Storage/storageAccounts/sysstorecbudwprod001"
    }
    pe4 = {
      resource_name                 = "sysstorecbudwprod001"         # Mysql Server name
      name                          = "pe-synstore-cbudw-002" # Private Endpoint name <resource_name>-pe
      subnet_id                     = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/rg-network-shared-prod-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-001/subnets/snet-prod-we-001"
      subnet_name                   = "snet-prod-we-001"
      vnet_name                     = "vnet-prod-we-001"
      networking_resource_group     = "rg-network-shared-prod-001"
      group_ids                     = ["dfs"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = null
      dns_rg_name                   = null
      dns_zone_group_name           = null
      private_connection_address_id = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/Rg-syn-prod-we-002/providers/Microsoft.Storage/storageAccounts/sysstorecbudwprod001"
    }        
    /*pe2 = {
      resource_name                 = "[__key_vault_name__]"
      name                          = "privateendpointkeyvault"
      subnet_id                     = "/subscriptions/[__subscription_id__]/resourceGroups/[__networking_resource_group_name__]/providers/Microsoft.Network/virtualNetworks/[__virtual_network_name__]/subnets/proxy"
      subnet_name                   = "[__subnet_name__]"
      vnet_name                     = "[__vnet_name__]"
      networking_resource_group     = "[__vnet_resource_group_name__]"
      group_ids                     = ["vault"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = null
      dns_rg_name                   = null
      dns_zone_group_name           = null
      private_connection_address_id = "/subscriptions/[__subscription_id__]/resourceGroups/[__resource_group_name__]/providers/Microsoft.KeyVault/vaults/[__key_vault_name__]"
    }
    pe3 = {
      resource_name                 = "[__automationaccount_name__]"
      name                          = "privateendpointautomationaccount"
      subnet_id                     = "/subscriptions/[__subscription_id__]/resourceGroups/[__networking_resource_group_name__]/providers/Microsoft.Network/virtualNetworks/[__virtual_network_name__]/subnets/proxy"
      subnet_name                   = "[__subnet_name__]"
      vnet_name                     = "[__vnet_name__]"
      networking_resource_group     = "[__vnet_resource_group_name__]"
      group_ids                     = ["DSCAndHybridWorker"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = ["privatelink.azure-automation.net"]
      dns_rg_name                   = null
      dns_zone_group_name           = "automationaccount"
      private_connection_address_id = "/subscriptions/[__subscription_id__]/resourceGroups/[__resource_group_name__]/providers/Microsoft.Automation/automationAccounts/[__automationaccount_name__]"
    },
    pe4 = {
      resource_name                 = "functionapp08252021c"
      name                          = "privateendpointfunctionapp"
      subnet_id                     = "/subscriptions/[__subscription_id__]/resourceGroups/[__networking_resource_group_name__]/providers/Microsoft.Network/virtualNetworks/[__virtual_network_name__]/subnets/proxy"
      subnet_name                   = "[__subnet_name__]"
      vnet_name                     = "[__vnet_name__]"
      networking_resource_group     = "[__vnet_resource_group_name__]"
      group_ids                     = ["sites"]
      approval_required             = false
      approval_message              = null
      dns_zone_names                = ["azurewebsites.net"]
      dns_rg_name                   = null
      dns_zone_group_name           = "functionappdns"
      private_connection_address_id = "/subscriptions/[__subscription_id__]/resourceGroups/[__resource_group_name__]/providers/Microsoft.Web/sites/functionapp08252021c"
    }*/
  }
  environment         = "prod"
  project             = "cbudw"
  owner               = "jithin.murali@maf.ae"
  business_unit       = "Data and Analytics"
  confidentiality     = "Sensitive"
  operational_company = "MAFGS"
  technical_contact   = "santhosh.palanivel@maf.ae"
  Description         = "Synapse workspace created for cbudw."
}

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-we-001"
    storage_account_name = "stgiacprodwe001"
    container_name       = "coniacprodwe001"
    key                  = "pe-syn-cbudw-prod-002.tfstate"
  }
}
