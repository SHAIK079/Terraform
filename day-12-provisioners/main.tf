terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "example" {
  key_name   = "my-public"
  public_key = file("C:/Users/SHAIK MAHAMMAD SAMI/.ssh/id_ed25519.pub")
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sami-vpc"
  }
}

# Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
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

# Security Group
resource "aws_security_group" "sg" {
  name = "provisioner-sg"
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

# EC2 Instance
resource "aws_instance" "server" {

  ami                    = "ami-0b826bb6d96d2afe4"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.example.key_name
  subnet_id              = aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  associate_public_ip_address = true



  # connection and provisioners...

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo apt update -
#               sudo apt install -y mysql-client
#               EOF

  tags = {
    Name = "amazonServer"
  }


  connection {
    type        = "ssh"
    user        = "ec2-user"                          # ✅ Correct for amazon AMIs
    private_key = file("C:/Users/SHAIK MAHAMMAD SAMI/.ssh/id_ed25519")          # Path to private key
    host        = self.public_ip  #or we can use aws_instance.server.public_ip
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "file10.txt"
    destination = "/home/ec2-user/file10.txt" #destination path on the remote instance copy the file10 from local to remote instance with the name file10
  }

  provisioner "remote-exec" {
    inline = [
      "touch /home/ec2-user/file200.txt",
      "echo 'hello from shaik shaik' >> /home/ec2-user/file200.txt"
    ]
  }
   provisioner "local-exec" {
    command = "echo. > file500.txt" 
    
   
 }
}

# resource "null_resource" "run_script" {
#   provisioner "remote-exec" {
#     connection {
#       host        = aws_instance.server.public_ip
#       user        = "ubuntu"
#       private_key = file("~/.ssh/id_ed25519")
#     }
#      provisioner "file" {
#     source      = "file10"
#     destination = "/home/ubuntu/dev.sh" #destination path on the remote instance copy the file10 from local to remote instance with the name file10
#   }


#     inline = [
#       "echo 'hello from veera Nareshit' >> /home/ubuntu/file200",
      
#         #"bash /home/ubuntu/dev.sh" # Assuming test.sh is already on the instance 
#     ]
#   }

#   triggers = {
#     always_run = "${timestamp()}" # This will ensure the provisioner runs every time you apply, as the timestamp will always change.
#   }
# #   triggers = {
# #   script_hash = filemd5("dev.sh") # Rerun only if script changes
# # }
# }


#Solution-2 to Re-Run the Provisioner
# Use terraform taint to manually mark the resource for recreation:
# terraform taint aws_instance.server
# terraform apply


/* Local Execution → My computer does the work.
 Remote Execution → Another server does the work.
File Execution → A file provides the input values.*/
  