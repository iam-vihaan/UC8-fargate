terraform {
  backend "s3" {
    bucket       = "kasi-hcl-bucket-uc8"
    key          = "kasi-hcl-bucket-uc8/statefile.tfstate"
    region       = "us-east-1"
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
