resource "aws_vpc" "sami" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.sami.id
  cidr_block        = var.subnet_1_cidr_block
  availability_zone = var.subnet_1_az

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.sami.id
  cidr_block        = var.subnet_2_cidr_block
  availability_zone = var.subnet_2_az

  tags = {
    Name = "private"
  }
}