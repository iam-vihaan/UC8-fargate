terraform {
  backend "s3" {
    bucket       = "usecases-terraform-state-bucket"
    key          = "usecase8/statefile.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}

terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "healthcare-app"
      ManagedBy   = "terraform"
    }
  }
}
