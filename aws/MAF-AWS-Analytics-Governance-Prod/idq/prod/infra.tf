#--------------------------------------
# Providers Block
#--------------------------------------
provider "aws" {
  region = "eu-west-1"
}
module "security_group_ec2" {
  source = "../../../../modules/aws/security_group"
  aws_region                 = "eu-west-1"
  environment                = "Prod"
  project                    = "IDQ"
  business_unit              = "Holdings"
  owner                      = "Saif.Khan@maf.ae"
  technical_owner            = "Harikrishna.Kamireddy-e@maf.ae"
  operational_company        = "MAF-Holdings"
  aws_vpc_id                 = "vpc-0954310b44d465ddd"
  sequence_of_security_group = 1
  aws_security_group_ingress = [
    {
      self        = false
      cidr_blocks = ["10.143.0.25/32", "10.143.16.25/32", "10.143.0.53/32", "10.143.16.44/32"]
      description = "1"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
  ]
  aws_security_group_egress  = [{
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
      description = "default outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }]
}
module "security_group_rds" {
  source = "../../../../modules/aws/security_group"
  aws_region                 = "eu-west-1"
  environment                = "Prod"
  project                    = "IDQ"
  business_unit              = "Holdings"
  owner                      = "Saif.Khan@maf.ae"
  technical_owner            = "Harikrishna.Kamireddy-e@maf.ae"
  operational_company        = "MAF-Holdings"
  aws_vpc_id                 = "vpc-0954310b44d465ddd"
  sequence_of_security_group = 2
  aws_security_group_ingress = [
    {
      self        = false
      cidr_blocks = ["10.143.0.25/32", "10.143.16.25/32", "10.143.0.53/32", "10.143.16.44/32"]
      description = "1"
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
    }
  ]
  aws_security_group_egress  = [{
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
      description = "default outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
    }]
}
module "ec2" {
    source            = "../../../../modules/aws/ec2"
    environment       = "Prod"
    business_unit     = "Holdings"
    owner             = "Saif.Khan@maf.ae"
    project           = "IDQ"
    aws_instance_type = "m4.xlarge"
    aws_ami_owner     = "646723929624"
    aws_ami_name      = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
    aws_ami_tags      = {
        # name  = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
        #"Application" = "base",
        #"OS"          = "Linux",
        #"OS_Version"  = "7.9",
        # "Runner"      = "EC2"
    }
    aws_instance_key_name         = "idq-governance-prod"
    aws_ami_name_regex            = "Golden-AMI-RHEL-7.6-Auth-Encrypted-Mar-2022"
    aws_kms_key_arn               = "arn:aws:kms:eu-west-1:620936384865:key/58402011-855a-463b-b93a-6caf35ddd071"
    aws_subnet_id                 = "subnet-03c5f4989db600ae5"
    is_secondary_volume_encrypted = true
    aws_secondary_volume_count    = 1
    aws_security_group_id         = module.security_group_ec2.aws_security_group_output
    aws_root_volume_size          = "100"
    aws_root_volume_type          = "gp2"
    aws_instance_profile_name     = ""
    aws_ebs_device_name           = ["/dev/xvdb"]
    aws_ec2_instance_sequence = "001"
    location_code             = "AIR1A"
    client_code               = "P"
    device_role               = "AP"
    environment_code          = "P"
    aws_secondary_volume_size = 250
    aws_secondary_volume_type = "gp2"
    operational_company       = "MAF-Holdings"
    technical_owner           = "Harikrishna.Kamireddy-e@maf.ae"
    user_data = "script.sh"
    depends_on                = [module.security_group_ec2]
}
module "db" {
    source              = "../../../../modules/aws/rds"
  project             = "idq"
  environment         = "prod"
  business_unit       = "Holdings"
  owner               = "Saif.Khan@maf.ae"
  operational_company = "MAF-Holdings"
  confidentiality      = "Critical"
  technical_owner = "Harikrishna.Kamireddy-e@maf.ae"
  engine               = "oracle-se2"
  engine_version       = "19.0.0.0.ru-2021-10.rur-2021-10.r1"
  family               = "oracle-se2-19.0" # DB parameter group
  major_engine_version = "19.0"           # DB option group
  instance_class       = "db.m5.xlarge"
  license_model        = "license-included"
  allocated_storage     = 100
  max_allocated_storage = 200
  # Make sure that database name is capitalized, otherwise RDS will try to recreate RDS instance every time
  name  = "ORACLE"
  username = "complete_oracle"
  port     = 1521
  multi_az               = true
  subnet_ids             = ["subnet-079e22110c2134f60", "subnet-09c600466adc5bd0b"]
  vpc_security_group_ids = [module.security_group_rds.aws_security_group_output]
  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["alert", "audit"]
  backup_retention_period = 7 #for automated backups
  skip_final_snapshot     = true
  deletion_protection     = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = false
  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name = "AL32UTF8"
  depends_on = [module.security_group_rds]
}
terraform {
  backend "s3" {    
    bucket ="governance-prod-tf-state"
    key    ="iactfstatefile/IDQInfra-tfstate"
    region ="eu-west-1"
  }
}
