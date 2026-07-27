terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "create_ec2" {
  default = false
}

resource "aws_instance" "web" {
  count = var.create_ec2 ? 1 : 0

  ami           = "ami-0c02fb55956c7d316" # Replace with a valid AMI
  instance_type = "t3.micro"

  tags = {
    Name = "Condition-EC2"
  }
}