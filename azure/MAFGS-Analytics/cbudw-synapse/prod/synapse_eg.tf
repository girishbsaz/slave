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

module "azurerm_synapse_workspace" {
  
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/synapse/?ref=dev"

  // Resource group
  create_resource_group    = true
  az_resource_group_name   = "rg-syn-prod-we-002"
  location                 = "westeurope"

  // Diagnostic settings details
  diagnostic_setting_name                    = "syn-prod-audit-logs-002"
  email_addresses_for_alerts                 = ["jithin.murali@maf.ae"]
  disabled_alerts                            = []
  Azure_AD_Authentication_User_Login_Name    = "santhosh.palanivel@maf.ae"
  threat_detection_audit_logs_retention_days = 7
  eventhub_authorization_rule_id             = "/subscriptions/fd8477fd-76fe-4ccf-a734-362fee139dfb/resourceGroups/mafpazcloudlogs-rg/providers/Microsoft.EventHub/namespaces/mafpazeventhubns/authorizationRules/RootManageSharedAccessKey"
  eventhub_name                              = "ehub-mafgs-analytics"


  public_network_access_enabled = false
  transparent_data_encryption = true

  //Synapse storage 
  create_storage_account   = true
  storage_account_name     = "synstorecbudwprod002"
  storage_account_resource_group_name = "rg-syn-prod-we-001"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  
  // ADLS 
  adls_name                           = "dls-syn-cbudw-prod-001"
  sql_admin_user                      = "mafgssqladmin"
  key_vault_resource_group_name       = "rg-mafgs-keys-we-001"
  key_vault_name                      = "kv-mafgs-prod-001"

  // SQL POOL
  syn_sql_pool_name        = "sql_cbudw_prod_001"
  sku_name                 = "DW100c"
  create_mode              = "Default"

  //tags
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
    key                  = "syn-cbudw-prod-002.tfstate"
  }
}
