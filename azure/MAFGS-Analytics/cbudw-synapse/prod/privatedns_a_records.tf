provider "azurerm" {
  features {}
}

module "dns_a_record" {
  source = "git::ssh://git@github.com/GS-MAFTech/iac-tf-modules.git//azure/privatedns_a_records/?ref=dev"
  private_records = {
    a1 = {
      dns_zone_resource_group = "mafp-it-shared-rg"
      resource_name           = "pe-syn-cbudw-001"
      ip_address              = ["10.100.218.14"]
      dns_zone_name           = "privatelink.sql.azuresynapse.net"
    },
    a2 = {
      dns_zone_resource_group = "mafp-it-shared-rg"
      resource_name           = "pe-syn-cbudw-002"
      ip_address              = ["10.100.218.15"]
      dns_zone_name           = "privatelink.dev.azuresynapse.net"
    },
    a3 = {
      dns_zone_resource_group = "mafp-it-shared-rg"
      resource_name           = "pe-synstore-cbudw-001"
      ip_address              = ["10.100.218.16"]
      dns_zone_name           = "privatelink.blob.core.windows.net"
    },
    a4 = {
      dns_zone_resource_group = "mafp-it-shared-rg"
      resource_name           = "pe-synstore-cbudw-002"
      ip_address              = ["10.100.218.17"]
      dns_zone_name           = "privatelink.dfs.core.windows.net"
    }       
  }
}
