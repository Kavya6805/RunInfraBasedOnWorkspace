provider "aws" {
    region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-file-stroage-v1"
    key    = "basiterraformpipeline.tf"
    region = "ap-south-1"
  }
}   

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}