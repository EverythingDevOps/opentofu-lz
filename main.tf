# main.tf - Root module for AWS Landing Zone

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Create a VPC for the landing zone
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  environment         = var.environment
}

# Set up S3 bucket and policies
module "s3_storage" {
  source = "./modules/s3"
  
  bucket_name         = var.bucket_name
  environment         = var.environment
}

# Set up ECS cluster with workers
module "ecs_cluster" {
  source = "./modules/ecs"
  
  cluster_name        = var.cluster_name
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  public_subnets      = module.vpc.public_subnets
  worker_count        = 2
  environment         = var.environment
}

# Set up CloudWatch for monitoring
module "monitoring" {
  source = "./modules/monitoring"
  
  cluster_name        = var.cluster_name
  environment         = var.environment
}
