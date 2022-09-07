provider "azurerm" {
  features {}
}

module "paloalto_vmseries" {
  source                = "../../../../modules/azure/paloalto"
  location              = "uaenorth"
  resource_group_name   = "rg-fw-prod-un-001"
  Public_ip_name        = "pip-fwmgmt-prod-un-01"
  Public_ip_name1       = "pip-fwmgmt-prod-un-02"
  availability_set_name = "as-fw-prod-01"
  vm_series_name        = "vmseriesfwprod1"
  vm_series_name2       = "vmseriesfwprod2"
  username              = "mafgspanadmin"
  key_vault_name        = "kv-uaehub-prod-un-01"
  key_vault_resource_group_name = "rg-uaehub-prod-un-001"
  untrust_public_ip_name1       = "pip-fwuntrust-prod-un-01"
  untrust_public_ip_name2       = "pip-fwuntrust-prod-un-02"

  mgmt_nic_name         = "nic-fwmgmt-prod-01"
  trust_nic_name        = "nic-fwtrust-prod-01"
  untrust_nic_name      = "nic-fwuntrust-prod-01"
  ha_nic_name           = "nic-fwha-prod-01"
  mgmt_nic_name1        = "nic-fwmgmt-prod-02"
  trust_nic_name1       = "nic-fwtrust-prod-02"
  untrust_nic_name1     = "nic-fwuntrust-prod-02"
  ha_nic_name1          = "nic-fwha-prod-02"
  mgmt_subnet_id        = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-uaehub-prod-un-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-un-001/subnets/snet-fw-mgmt-001"
  trust_subnet_id       = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-uaehub-prod-un-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-un-001/subnets/snet-fw-trust-001"
  untrust_subnet_id     = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-uaehub-prod-un-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-un-001/subnets/snet-fw-untrust-001"
  ha_subnet_id          = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-uaehub-prod-un-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-un-001/subnets/snet-fw-ha-001"

  environment           = "prod"
  project               = "infrastructure"
  business_unit         = "GS-MafTech"
  owner                 = "gregory.naidoo@maf.ae"
  operational_company   = "MAFGS"
  technical_contact     = "sandeep.nagaraju-e@maf.ae"

}

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-un-001"
    storage_account_name = "stgiacprodun002"
    container_name       = "gshubtfstate"
    key                  = "paloalto.tfstate"
  }
}
