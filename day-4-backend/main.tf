resource "aws_instance" "demo" {

  ami           = "ami-01edba92f9036f76e"

  instance_type = "t3.micro"

  tags = {
    Name = "LockDemo"
  }
}