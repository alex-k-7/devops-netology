provider "aws" {
  region = "eu-west-2"
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "test"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  tags = { Name = "Test" }
}
