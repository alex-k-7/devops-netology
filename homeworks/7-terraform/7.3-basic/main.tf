provider "aws" {
  region = "eu-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  test_instance_type_map = {
    stage = "t2.micro"
    prod = "t2.large"
  }
  test_instance_count_map = {
    stage = 1
    prod = 2
  }
  test2_prod_count_map = toset(["0" ,"1"])
  test2_stage_count_map = toset(["0"])
}

resource "aws_instance" "test" {
  ami = data.aws_ami.ubuntu.id
  instance_type = local.test_instance_type_map[terraform.workspace]
  count = local.test_instance_count_map[terraform.workspace]
  associate_public_ip_address = true
}

resource "aws_instance" "test2" {
  for_each = "${terraform.workspace == "prod" ? local.test2_prod_count_map : local.test2_stage_count_map}"
  ami = data.aws_ami.ubuntu.id
  instance_type = local.test_instance_type_map[terraform.workspace]
  lifecycle {
    create_before_destroy = true
  }
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
