    resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "sami-vpc"
    }
    }

    # Public Subnet 1
    resource "aws_subnet" "public_subnet_1" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.6.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"

    tags = {
        Name = "public-subnet-1"
    }
    }

    # Private Subnet
    resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.my_vpc.id
    cidr_block = "10.0.4.0/24"

    tags = {
        Name = "private-subnet"
    }
    }

    # Public Subnet 2
    resource "aws_subnet" "public_subnet_2" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.5.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1b"

    tags = {
        Name = "public-subnet-2"
    }
    }

    resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "sami-igw"
    }
    }

    resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }

    tags = {
        Name = "public-rt"
    }
    }

    resource "aws_route_table_association" "public_assoc_1" {
    subnet_id      = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_rt.id
    }

    resource "aws_route_table_association" "public_assoc_2" {
    subnet_id      = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_rt.id
    }

    resource "aws_eip" "nat_eip" {
    domain = "vpc"

    tags = {
        Name = "nat-eip"
    }
    }

    resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.public_subnet_1.id

    depends_on = [aws_internet_gateway.my_igw]

    tags = {
        Name = "nat-gateway"
    }
    }

    resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }

    tags = {
        Name = "private-rt"
    }
    }

    resource "aws_route_table_association" "private_assoc" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
    }
    #craeting security group
    resource "aws_security_group" "my_sg" {
    name   = "sami-sg"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sami-sg"
    }
    }
    #craeting rds security group
    resource "aws_security_group" "rds_sg" {
    name   = "rds-sg"
    vpc_id = aws_vpc.my_vpc.id

 

    # Allow external access from local machine (change for production!)
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }

    resource "aws_db_subnet_group" "rds_subnet_group" {
    name = "sami-rds-subnet-group"

    subnet_ids = [
        aws_subnet.public_subnet_1.id,
        aws_subnet.public_subnet_2.id
    ]

    tags = {
        Name = "sami-rds-subnet-group"
    }
    }

   resource "aws_db_instance" "rds" {
  identifier = "sami-rds09"

  allocated_storage = 20

  engine         = "mysql"
  engine_version = "8.0.46"

  instance_class = "db.t3.micro"

  username = "admin"
  password = "Shaiksami123"

  db_name = "sami"

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name

  publicly_accessible = true

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  skip_final_snapshot = false

  tags = {
    Name = "sami-rds"
  }
}
    



# Use null_resource to execute the SQL script from your local machine
resource "null_resource" "local_sql_exec" {
  depends_on = [aws_db_instance.rds]

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.rds.address} -u admin -pShaiksami123 sami < init.sql"
  }

  triggers = {
    always_run = timestamp()
  }
}