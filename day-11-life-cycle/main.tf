provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sam" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.medium"

  tags = {
    Name = "my-server"
  }

  lifecycle {
    create_before_destroy = true
  }
}