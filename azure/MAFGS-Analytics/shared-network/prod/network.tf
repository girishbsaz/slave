provider "azurerm" {
  features {}
}
data "azurerm_client_config" "current" {}
module "az_vnet" {
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/vnet/?ref=v1.0.0"
  environment         = "prod"
  owner               = "gregory.naidoo@maf.ae"
  business_unit       = "GS-MafTech"
  project             = "Infra"
  operational_company = "MAFGS"
  location                    = "westeurope"
  location_abbreviation       = "we"
  az_resource_group_name      = "rg-network-shared-prod-001"
  az_vnet_sequence            = "001"
  az_vnet_cidr                = ["10.100.218.0/24"]
  az_dns_servers              = ["10.100.210.11", "172.31.201.11", "172.31.201.12"]
  enable_ddos_protection_plan = false
  ddos_protection_plan_id     = null
  technical_contact           = "kamalraj.singaram-e@maf.ae"
  #depends_on                  = [module.rg_test]
}
module "az_nsg" {
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/nsg/?ref=v1.0.0"
  environment            = "prod"
  owner                  = "gregory.naidoo@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "Infra"
  operational_company    = "MAFGS"
  technical_contact      = "kamalraj.singaram-e@maf.ae"
  location               = "westeurope"
  az_resource_group_name = "rg-network-shared-prod-001"
  az_nsg_sequence        = "001"
}
### tags needs to be handled inside the module.
module "az_subnet" {
  source                 = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/subnet/?ref=v1.0.0"
  environment            = "prod"
  location               = "westeurope"
  location_abbreviation  = "we"
  az_resource_group_name = "rg-network-shared-prod-001"
  az_subnet_sequence     = "001"
  az_subnet_cidr         = "10.100.218.0/26"
  az_nsg_id              = module.az_nsg.az_nsg_id_output
  az_route_table_id      = module.az_route_table.az_route_table_id_output
  az_vnet_name           = module.az_vnet.az_virtual_network_name_output
  depends_on             = [module.az_vnet]
}
module "az_route_table" {
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/route_table/?ref=v1.0.0"
  environment         = "prod"
  owner                  = "gregory.naidoo@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "Infra"
  operational_company    = "MAFGS"
  technical_contact      = "kamalraj.singaram-e@maf.ae"
  location               = "westeurope"
  az_route_table_name    = "syn-prod-001"
  az_resource_group_name = "rg-network-shared-prod-001"
  az_route_table_routes = [
    {
      name           = "Internet",
      address_prefix = "0.0.0.0/0",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.100.161.4"
    },
    {
      name           = "MAFGSSYN-to-DC-Miraki",
      address_prefix = "172.16.0.0/12",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.100.164.6"
    },
    {
      name           = "MAFGSSYN-to-DC-Miraki01",
      address_prefix = "10.0.0.0/8",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.100.164.6"
    },
    {
      name           = "Azure-Internal",
      address_prefix = "10.100.210.0/24",
      next_hop_type  = "VirtualAppliance"
      next_hop_in_ip_address = "10.100.161.4"
    },
  ]
}
terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-we-001"
    storage_account_name = "stgiacprodwe001"
    container_name       = "coniacprodwe001"
    key                  = "Networksyn.tfstate"
  }
}
