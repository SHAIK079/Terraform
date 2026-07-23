
/*resource "aws_security_group" "devops-project-sami" {
  name        = "devops-project-sami"
  description = "Allow TLS inbound traffic"

 ingress {
     description      = "SSH inbound rule"
     from_port        = 22
     to_port          = 22
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
     description      = "HTTP inbound rule"
     from_port        = 80
     to_port          = 80
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
     description      = "HTTPS inbound rule"
    from_port        = 443
     to_port          = 443
     protocol         = "tcp"
     cidr_blocks      = ["0.0.0.0/0"]
 }
}*/

   /* ingress = [
    for port in [80, 443, 8080, 9000, 3000, 8082, 8081] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-project-veera"
  }
}*/

locals {
  # local.ingress_rules defines a reusable list of ingress rule objects.
  # Each object contains the port, description, and the CIDR blocks that are allowed.
  # This local value is separate from the aws_security_group resource.
  ingress_rules = [
    { port = 80,  description = "HTTP",  cidrs = ["10.0.0.0/24"] },
    { port = 443, description = "HTTPS", cidrs = ["10.0.1.0/24"] },
    { port = 3000, description = "App",  cidrs = ["10.0.2.0/24"] },
  ]
}

resource "aws_security_group" "devops-project-sami" {
  name        = "devops-project-sami"
  description = "Allow TLS inbound traffic"

  ingress = [
    # The for expression below loops over each element in local.ingress_rules.
    # For each rule object, Terraform creates one map representing an ingress block.
    for rule in local.ingress_rules : {
      description      = rule.description
      from_port        = rule.port
      to_port          = rule.port
      protocol         = "tcp"
      cidr_blocks      = rule.cidrs
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "devops-project-veera" }
}