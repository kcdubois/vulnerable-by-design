terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.61.0"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

provider "aws" {
}
