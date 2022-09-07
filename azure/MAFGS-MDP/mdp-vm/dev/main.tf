provider "azurerm" {
  features {}
}

resource "azurerm_windows_virtual_machine" "Virtual_Machine" {
    resource_group_name = "rg-mdp-dev-un-001"
    location ="uaenorth"
    name = "AZRDNPCIAPVDB76"
    size = "Standard_D4ds_v5"
    network_interface_ids = [
              "/subscriptions/21586526-8b94-485b-bf6d-69af0df26751/resourceGroups/rg-mdp-dev-un-001/providers/Microsoft.Network/networkInterfaces/azrdnpciapvdb76569"
            ]
    admin_username = "mdpadmin"
    admin_password = "ignored-as-imported"
    encryption_at_host_enabled = false
    source_image_id = "/subscriptions/6266782b-aed7-47c4-b666-7bc90b9d332e/resourceGroups/RG-MAFGS-IMAGES/providers/Microsoft.Compute/galleries/GalleryGoldenAMI/images/az-sig-win-2016-base/versions/4.0.0"
    vtpm_enabled               = false
    os_disk {
                caching = "ReadWrite"
                #diff_disk_settings = []
                #disk_encryption_set_id = ""
                disk_size_gb = 127
                name= "AZRDNPCIAPVDB76_OsDisk_1_3caa70e9288049829b423f4e51628b68"
                #secure_vm_disk_encryption_set_id= ""
                #security_encryption_type= ""
                storage_account_type= "StandardSSD_LRS"
                write_accelerator_enabled= false
    }
    tags  = {
            BusinessUnit     = "GS-MafTech"
            Description      = "Virtual Machine created for MDP dev environment"
            Environment      = "Dev"
            Name             = "AZRDNPCIAPVDB76"
            OpCo             = "MAFGS"
            Owner            = "sunil.chavan@maf.ae"
            Project          = "mdp"
            TechnicalContact = "santhosh.palanivel@maf.ae"
        }
}

terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "rg-mdp-iac-prod-un-001"
    storage_account_name = "stgmdpiacprodun001"
    container_name       = "gsmdptfstate"
    key                  = "MDP_VM.tfstate"
  }
}
