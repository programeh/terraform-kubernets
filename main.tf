module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.12.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.12.1.0/24", "10.12.2.0/24", "10.12.3.0/24"]
  public_subnets  = ["10.12.4.0/24", "10.12.5.0/24", "10.12.6.0/24"]

  enable_nat_gateway = true
  single_nat_gateway  = true
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "kubernets-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]
  }

  eks_managed_node_groups = {
    nginx-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator

  enable_cluster_creator_admin_permissions = true

  # cloudwatch retention days
  cloudwatch_log_group_retention_in_days=3


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}