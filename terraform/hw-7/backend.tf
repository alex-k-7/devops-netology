terraform {
  backend "s3" {
    bucket = "aks-trf-state"
    key    = "main/terraform.tfstate"
    region = "eu-west-2"
  }
}