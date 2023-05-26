terraform {
  required_version = ">= 1.3.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }

}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account]
}
