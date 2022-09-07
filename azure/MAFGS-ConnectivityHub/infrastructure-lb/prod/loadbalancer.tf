provider "azurerm" {
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.59.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-iac-prod-un-001"
    storage_account_name = "stgiacprodun002"
    container_name       = "gshubtfstate"
    key                  = "paloadbalancer.tfstate"
  }  
}

module "azurerm_lb" {
  source                = "../../../../modules/azure/loadbalancer"
  resource_group_name      = "rg-fw-prod-un-001"
  location                 = "uaenorth"
  vnet_resource_group_name = "rg-uaehub-prod-un-001"
  virtual_network_name     = "vnet-prod-un-001"
  subnet_name              = "snet-fw-trust-001"
  nic_resource_group_name  = "rg-fw-prod-un-001"
  load_balancer_sku        = "Standard"
  load_balancer_name             = "lb-fw-prod-un-01"
  frontend_ip_configuration_name = "lb-fw-prod-frontendip-01"
  load_balancer_backendpool_name = "lb-fw-prod-bepool-01"
  Environment      = "prod"
  Project          = "infrastructure"
  Owner            = "gregory.naidoo@maf.ae"
  BusinessUnit     = "GS-MafTech"
  OpCo             = "MAFGS"
  TechnicalContact = "sandeep.nagaraju-e@maf.ae"
  load_balancer_rules = {
    # loadbalancerrules1 = {
    #   name                      = "lb-fw-dev-lbrule-01"
    #   probe_name                = "lb-fw-dev-lbprobe-01"
    #   lb_key                    = "loadbalancer1"
    #   lb_protocol               = null
    #   lb_port                   = "22"
    #   probe_port                = "22"
    #   backend_port              = "22"
    #   enable_floating_ip        = null
    #   disable_outbound_snat     = null
    #   enable_tcp_reset          = null
    #   probe_protocol            = "Tcp"
    #   request_path              = "/"
    #   probe_interval            = 15
    #   probe_unhealthy_threshold = 2
    #   load_distribution         = "SourceIPProtocol"
    #   idle_timeout_in_minutes   = 5
    # }
    # loadbalancerrules2 = {
    #   name                      = "lb-fw-dev-lbrule-02"
    #   probe_name                = "lb-fw-dev-lbprobe-02"
    #   lb_key                    = "loadbalancer2"
    #   lb_protocol               = null
    #   lb_port                   = "80"
    #   probe_port                = "80"
    #   backend_port              = "80"
    #   enable_floating_ip        = null
    #   disable_outbound_snat     = null
    #   enable_tcp_reset          = null
    #   probe_protocol            = "Tcp"
    #   request_path              = "/"
    #   probe_interval            = 15
    #   probe_unhealthy_threshold = 2
    #   load_distribution         = "SourceIPProtocol"
    #   idle_timeout_in_minutes   = 5
    # }
  }
  load_balancer_nat_pools = {}
  lb_outbound_rules = {}
  load_balancer_nat_rules = {
    # loadbalancernatrules1 = {
    #   name                    = "lb-fw-dev-natrule-01"
    #   lb_keys                 = ["loadbalancer1"]
    #   frontend_ip_name        = "lb-fw-dev-frontendip-01"
    #   lb_port                 = 443
    #   backend_port            = 22
    #   idle_timeout_in_minutes = 5
    # }
  }
  network_interfaces = {
    networkinterface1 = {
      name                    = "nic-fwtrust-prod-01"
      network_interface_id    = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-fw-prod-un-001/providers/Microsoft.Network/networkInterfaces/nic-fwtrust-prod-01"
      ip_configuration_name   = "ipconfig-trust-fw-01"
    }
    networkinterface2 = {
      name                    = "nic-fwtrust-prod-02"
      network_interface_id    = "/subscriptions/efce9bb5-7de1-4c80-94d3-0494832076f8/resourceGroups/rg-fw-prod-un-001/providers/Microsoft.Network/networkInterfaces/nic-fwtrust-prod-02"
      ip_configuration_name   = "ipconfig-trust-fw-03"
    }
  }
}
