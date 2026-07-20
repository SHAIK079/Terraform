provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sam-server" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"

  tags = {
    Name = "sam-server"
  }
}

#terraform import aws-instance.name ami-01edba92f9036f76e