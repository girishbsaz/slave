#--------------------------------------
# Providers Block
#--------------------------------------
provider "aws" {
  region = "eu-west-1"
}
module "ec2" {

    source            = "../../../../modules/aws/ec2"

    environment       = "Dev"
    business_unit     = "MAFH"
    owner             = "Shivam Khandelwal"
    project           = "CI"
    aws_instance_type = "t2.large"
    aws_ami_owner     = "863485925838"
    aws_ami_name      = "aws-rhel-8.4-base-20220414"
    aws_ami_tags      = {
        # name  = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
        #"Application" = "base",
        #"OS"          = "Linux",
        #"OS_Version"  = "7.9",
        # "Runner"      = "EC2"
    }
    aws_instance_key_name         = "xsight-bastion"
    aws_ami_name_regex            = "aws-rhel-8.4-base-20220414"
    aws_kms_key_arn               = "arn:aws:kms:eu-west-1:447554467008:key/e40612f8-5879-4e20-9715-fcf8484af1ea"
    aws_subnet_id                 = "subnet-6562d102"
    is_secondary_volume_encrypted = true
    aws_secondary_volume_count    = 0
    aws_security_group_id         = "sg-0de1a292f862d1fa8"
    aws_root_volume_size          = "50"
    aws_root_volume_type          = "gp2"
    aws_instance_profile_name     = ""
    aws_ebs_device_name           = ["/dev/xvdb"]
    aws_ec2_instance_sequence = "B30"
    location_code             = "AIR1A"
    client_code               = "H"
    device_role               = "CI"
    environment_code          = "N"
    aws_secondary_volume_size = 250
    aws_secondary_volume_type = "gp2"
    operational_company       = "MAFH"
    technical_owner           = "Shivam Khandelwal"

}
module "ec2win" {

    source            = "../../../../modules/aws/ec2"

    environment       = "Dev"
    business_unit     = "MAFH"
    owner             = "Shivam Khandelwal"
    project           = "CI"
    aws_instance_type = "t2.large"
    aws_ami_owner     = "863485925838"
    aws_ami_name      = "aws-windows-2019-base-20220414"
    aws_ami_tags      = {
        # name  = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
        #"Application" = "base",
        #"OS"          = "Linux",
        #"OS_Version"  = "7.9",
        # "Runner"      = "EC2"
    }
    aws_instance_key_name         = "xsight-bastion"
    aws_ami_name_regex            = "aws-windows-2019-base-20220414"
    aws_kms_key_arn               = "arn:aws:kms:eu-west-1:447554467008:key/e40612f8-5879-4e20-9715-fcf8484af1ea"
    aws_subnet_id                 = "subnet-6562d102"
    is_secondary_volume_encrypted = true
    aws_secondary_volume_count    = 0
    aws_security_group_id         = "sg-0de1a292f862d1fa8"
    aws_root_volume_size          = "50"
    aws_root_volume_type          = "gp2"
    aws_instance_profile_name     = ""
    aws_ebs_device_name           = ["/dev/xvdb"]
    aws_ec2_instance_sequence = "B31"
    location_code             = "AIR1A"
    client_code               = "H"
    device_role               = "CI"
    environment_code          = "N"
    aws_secondary_volume_size = 250
    aws_secondary_volume_type = "gp2"
    operational_company       = "MAFH"
    technical_owner           = "Shivam Khandelwal"

}
terraform {
  backend "s3" {    
    bucket ="terraform-tf-xsight-bastion-host"
    key    ="iactfstatefile/xsightInfra-tfstate"
    region ="eu-west-1"
  }
}
