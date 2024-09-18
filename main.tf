#module "vpc" {
#  source = "terraform-aws-modules/vpc/aws"
#
#  name = "my-vpc"
#  cidr = "10.12.0.0/16"
#
#  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
#  private_subnets = ["10.12.1.0/24", "10.12.2.0/24", "10.12.3.0/24"]
#  public_subnets  = ["10.12.4.0/24", "10.12.5.0/24", "10.12.6.0/24"]
#
#  enable_nat_gateway = true
#  single_nat_gateway  = true
#  enable_vpn_gateway = false
#
#  tags = {
#    Terraform = "true"
#    Environment = "dev"
#  }
#}
