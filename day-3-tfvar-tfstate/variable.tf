variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-01edba92f9036f76e"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "tags" {
  description = "Name tag for the instance"
  type        = string
  default     = "my-instance"
}