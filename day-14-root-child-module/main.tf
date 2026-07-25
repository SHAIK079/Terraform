
module "vpc" {
  source = "./module/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "s3" {
  source = "./module/s3"

  bucket_name = var.bucket_name
}

module "ec2" {
  source = "./module/ec2"

  ami           = var.ami
  instance_type = var.instance_type
  instance_name = var.instance_name
}

module "rds" {
  source = "./module/rds"

  identifier         = var.identifier
  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  db_name            = var.db_name
  username           = var.username
  password           = var.password
 
}