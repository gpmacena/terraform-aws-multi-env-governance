terraform {
  backend "s3" {
    bucket  = "gabrielmacena-final-project-terraform"
    key     = "enterprise-governance/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }
}