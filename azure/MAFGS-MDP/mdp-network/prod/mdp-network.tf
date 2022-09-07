provider "azurerm" {
  features {}
}
data "azurerm_client_config" "current" {}

locals {
  current_object_id = data.azurerm_client_config.current.object_id

}

module "az_vnet" {
  source = "git::https://git@github.com/gisrishbsaz/master.git//azure/vnet/?ref=main"
  
  environment                 = "prod"
  owner                       = "sunil.chavan@maf.ae"
  business_unit               = "GS-MafTech"
  project                     = "mdp"
  operational_company         = "MAFGS"
  location                    = "uaenorth"
  location_abbreviation       = "un"
  az_resource_group_name      = "vnetrg"
  az_vnet_sequence            = "001"
  az_vnet_cidr                = ["10.180.32.0/27"]
  az_dns_servers              = []
  enable_ddos_protection_plan = false
  ddos_protection_plan_id     = null
  technical_contact           = "santhosh.palanivel@maf.ae"
}

module "az_nsg" {
  source = "git::https://git@github.com/girishbsaz/master.git//azure/nsg/?ref=main"
  environment            = "prod"
  owner                  = "sunil.chavan@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "mdp"
  operational_company    = "MAFGS"
  technical_contact      = "santhosh.palanivel@maf.ae"
  location               = "uaenorth"
  az_resource_group_name = "vnetrg"
  az_nsg_sequence        = "001"
}

### tags needs to be handled inside the module.
module "az_subnet" {
  source                 = "git::https://git@github.com/girishbsaz/master.git//azure/subnet/?ref=main"
  environment            = "prod"
  location               = "uaenorth"
  location_abbreviation  = "un"
  az_resource_group_name = "vnetrg"
  az_subnet_sequence     = "001"
  az_subnet_cidr         = "10.180.32.0/27"
  az_nsg_id              = module.az_nsg.az_nsg_id_output
  az_route_table_id      = module.az_route_table.az_route_table_id_output
  az_vnet_name           = module.az_vnet.az_virtual_network_name_output
  depends_on             = [module.az_vnet]
}
module "az_route_table" {
  source = "git::https://git@github.com/girishbsaz/master.git//azure/route_table/?ref=main"
  environment         = "prod"
  owner                  = "sunil.chavan@maf.ae"
  business_unit          = "GS-MafTech"
  project                = "mdp"
  operational_company    = "MAFGS"
  technical_contact      = "santhosh.palanivel@maf.ae"
  location               = "uaenorth"
  az_route_table_name    = "route-mdp-prod-001"
  az_resource_group_name = "vnetrg"
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
}
