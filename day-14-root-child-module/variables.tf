variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "The name to assign to the VPC."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "ami" {}

variable "instance_type" {}

variable "instance_name" {}

variable "identifier" {}

variable "engine" {}

variable "engine_version" {}

variable "instance_class" {}

variable "allocated_storage" {}

variable "db_name" {}

variable "username" {}

variable "password" {}



