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
    owner             = "Suraj Rajan"
    project           = "Demo"
    aws_instance_type = "t2.micro"
    aws_ami_owner     = "863485925838"
    aws_ami_name      = "aws-rhel-8.4-base-20220414"
    aws_ami_tags      = {
        # name  = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
        #"Application" = "base",
        #"OS"          = "Linux",
        #"OS_Version"  = "7.9",
        # "Runner"      = "EC2"
    }
    aws_instance_key_name         = "menna"
    aws_ami_name_regex            = "aws-rhel-8.4-base-20220414"
    aws_kms_key_arn               = "arn:aws:kms:eu-west-1:863485925838:key/mrk-177ee8f8ca01444799c4ba49ffd0f27f"
    aws_subnet_id                 = "subnet-001abb020842386d3"
    is_secondary_volume_encrypted = true
    aws_secondary_volume_count    = 0
    aws_security_group_id         = "sg-00f36fbf5b5142178"
    aws_root_volume_size          = "50"
    aws_root_volume_type          = "gp2"
    aws_instance_profile_name     = "AmazonSSMRoleForInstancesQuickSetup"
    aws_ebs_device_name           = ["/dev/xvdb"]
    aws_ec2_instance_sequence = "B32"
    location_code             = "AIR1A"
    client_code               = "H"
    device_role               = "CI"
    environment_code          = "N"
    aws_secondary_volume_size = 250
    aws_secondary_volume_type = "gp2"
    operational_company       = "MAFH"
    technical_owner           = "Suraj Rajan"

}

terraform {
  backend "s3" {    
    bucket ="tf-poc-bucket-state"
    key    ="iacdemostatefile/demo-tfstate"
    region ="eu-west-1"
  }
}
