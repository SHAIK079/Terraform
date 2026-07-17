module "sami" {
    source = "../day-9-module-ec2"
    vpc_cidr_block = "10.0.0.0/16"
    aws_region = "us-east-1"
    subnet_1_cidr_block = "10.0.0.0/24"
    subnet_2_cidr_block = "10.0.1.0/24"
    subnet_1_az = "us-east-1a"
    subnet_2_az = "us-east-1b"

    




}