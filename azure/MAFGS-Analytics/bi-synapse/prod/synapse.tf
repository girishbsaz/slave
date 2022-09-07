# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">= 2.59.0"
#     }
#     random = {
#       source = "hashicorp/random"
#     }
#   }
#   required_version = ">= 0.13"
# }

provider "azurerm" {
  features {}
}

module "azurerm_synapse_workspace" {
  
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/synapse/?ref=v1.0.0"

  // Resource group
  create_resource_group    = true
  az_resource_group_name   = "rg-syn-prod-we-001"
  location                 = "westeurope"

  // Diagnostic settings details
  diagnostic_setting_name                    = "syn-prod-audit-logs-001"
  email_addresses_for_alerts                 = ["Murali.krishna@maf.ae"]
  disabled_alerts                            = []
  Azure_AD_Authentication_User_Login_Name    = "santhosh.palanivel@maf.ae"
  threat_detection_audit_logs_retention_days = 7
  eventhub_authorization_rule_id             = "/subscriptions/fd8477fd-76fe-4ccf-a734-362fee139dfb/resourceGroups/mafpazcloudlogs-rg/providers/Microsoft.EventHub/namespaces/mafpazeventhubns/authorizationRules/RootManageSharedAccessKey"
  eventhub_name                              = "ehub-mafgs-analytics"


  public_network_access_enabled = false
  transparent_data_encryption = true

  //Synapse storage 
  account_tier             = "Standard"
  account_replication_type = "RAGRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  
  // ADLS 
  adls_name                           = "syn-adls"
  sql_admin_user                      = "mafgssqladmin"
  key_vault_resource_group_name       = "rg-mafgs-keys-we-001"
  key_vault_name                      = "kv-mafgs-prod-001"

  // SQL POOL
  syn_sql_pool_name        = "sp_syn_prod_001"
  sku_name                 = "DW100c"
  create_mode              = "Default"

  // Private endpoints
  pe_name                  = "pe-syn-dw-prod-001"
  pe_subnet                = "/subscriptions/b0cf611c-12d2-44e6-b829-4e0fd227297e/resourceGroups/rg-network-shared-prod-001/providers/Microsoft.Network/virtualNetworks/vnet-prod-we-001/subnets/snet-prod-we-001"
  pe_subnet_name           = "snet-prod-we-001"
  pe_vnet_name             = "vnet-prod-we-001"
  pe_resource_group        = "rg-network-shared-prod-001"
   
  //tags
  environment         = "prod"
  project             = "dw"
  owner               = "Rashmi.venkatesh@maf.ae"
  business_unit       = "Data and Analytics"
  confidentiality     = "Sensitive"
  operational_company = "MAFGS"
  technical_contact   = "Murali.krishna@maf.ae"
}

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-we-001"
    storage_account_name = "stgiacprodwe001"
    container_name       = "coniacprodwe001"
    key                  = "syn-dw-prod-001.tfstate"
  }
}
