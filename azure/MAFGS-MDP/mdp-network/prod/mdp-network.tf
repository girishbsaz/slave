provider "azurerm" {
  features {}
}
data "azurerm_client_config" "current" {}

locals {
  current_object_id = data.azurerm_client_config.current.object_id

}

module "az_resource_group" {
  source          = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/resourcegroup/?ref=dev"
  resource_groups = {
    resource_group_1 = {
        name     = "rg-mdp-prod-un-001"
        location = "uaenorth"
    }
  }

  environment         = "prod"
  project             = "mdp"
  owner               = "sunil.chavan@maf.ae"
  business_unit       = "GS-MafTech"
  operational_company = "MAFGS"
  technical_contact   = "santhosh.palanivel@maf.ae"
  Description         = "Resource group created for MDP project"
}

module "az_vnet" {
  source = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/vnet/?ref=v1.0.0"
  
  environment                 = "prod"
  owner                       = "sunil.chavan@maf.ae"
  business_unit               = "GS-MafTech"
  project                     = "mdp"
  operational_company         = "MAFGS"
  location                    = "uaenorth"
  location_abbreviation       = "un"
  az_resource_group_name      = "rg-mdp-prod-un-001"
  az_vnet_sequence            = "001"
  az_vnet_cidr                = ["10.180.32.0/27"]
  az_dns_servers              = []
  enable_ddos_protection_plan = false
  ddos_protection_plan_id     = null
  technical_contact           = "santhosh.palanivel@maf.ae"
  depends_on                  = [module.az_resource_group]
}

module "az_nsg" {
  source = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/nsg/?ref=v1.0.0"
  environment            = "prod"
  owner                  = "sunil.chavan@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "mdp"
  operational_company    = "MAFGS"
  technical_contact      = "santhosh.palanivel@maf.ae"
  location               = "uaenorth"
  az_resource_group_name = "rg-mdp-prod-un-001"
  az_nsg_sequence        = "001"
  depends_on = [
    module.az_resource_group
  ]
}

### tags needs to be handled inside the module.
module "az_subnet" {
  source                 = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/subnet/?ref=v1.0.0"
  environment            = "prod"
  location               = "uaenorth"
  location_abbreviation  = "un"
  az_resource_group_name = "rg-mdp-prod-un-001"
  az_subnet_sequence     = "001"
  az_subnet_cidr         = "10.180.32.0/27"
  az_nsg_id              = module.az_nsg.az_nsg_id_output
  az_route_table_id      = module.az_route_table.az_route_table_id_output
  az_vnet_name           = module.az_vnet.az_virtual_network_name_output
  depends_on             = [module.az_vnet, module.az_resource_group]
}
module "az_route_table" {
  source = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/route_table/?ref=v1.0.0"
  environment         = "prod"
  owner                  = "sunil.chavan@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "mdp"
  operational_company    = "MAFGS"
  technical_contact      = "santhosh.palanivel@maf.ae"
  location               = "uaenorth"
  az_route_table_name    = "route-mdp-prod-001"
  az_resource_group_name = "rg-mdp-prod-un-001"
  az_route_table_routes = [
    {
      name           = "Internet",
      address_prefix = "0.0.0.0/0",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.180.18.11"
    },
    {
      name           = "Azure-to-DC-Miraki01",
      address_prefix = "172.16.0.0/12",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.180.17.4"
    },
    {
      name           = "Azure-to-DC-Miraki02",
      address_prefix = "10.0.0.0/8",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.180.17.4"
    },
    {
      name           = "Azure-to-DC-Miraki03",
      address_prefix = "192.168.0.0/16",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.180.17.4"
    },    
    {
      name           = "Azure-Internal",
      address_prefix = "10.180.32.0/27",
      next_hop_type  = "VirtualNetworkGateway"
    },
  ]
  depends_on = [
    module.az_resource_group
  ]
}

module "az_key_vault" {
  source = "git::https://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/key_vault/?ref=dev"

  environment                    = "prod"
  project                        = "mdp"
  owner                          = "sunil.chavan@maf.ae"
  business_unit                  = "GS-MafTech"
  operational_company            = "MAFGS"
  Description                    = "Key vault created for storing keys,secrets etc.. with in mdp Project"
  location                       = "uaenorth"
  az_resource_group_name         = "rg-mdp-prod-un-001"
  location_abbreviation          = "un"
  soft_delete_retention_days     = 30
  az_key_vault_sequence          = "002"
  technical_contact              = "santhosh.palanivel@maf.ae"
  sku_name                       = "standard"
  az_diagnostic_setting_sequence = "001"

  access_policies = {
  }

  depends_on = [
    module.az_resource_group
  ]
  logs_destinations_ids = ["/subscriptions/9e32fa5d-e4a4-408a-8a99-445037637cb3/resourceGroups/rg-ehub-prod-un-001/providers/Microsoft.EventHub/namespaces/evhns-mafgs-un-001/authorizationRules/RootManageSharedAccessKey"]
}

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-un-001"
    storage_account_name = "stgmdpiacprod001"
    container_name       = "gsmdptfstate"
    key                  = "MDP_Network.tfstate"
  }
}