resource "aws_key_pair" "example" {
  key_name   = "my-public"
  public_key = file("C:/Users/SHAIK MAHAMMAD SAMI/.ssh/id_ed25519.pub")
}

data "aws_subnet" "public_subnet_1" {
  filter {
    name   = "tag:Name"
    values = ["public-subnet-1"]
  }
}

data "aws_security_group" "my_sg" {
  filter {
    name   = "tag:Name"
    values = ["sami-sg"]
  }
}

data "aws_db_instance" "rds" {
  db_instance_identifier = "sami-rds07"
}

resource "aws_instance" "sql_runner" {

  ami                         = "ami-0b826bb6d96d2afe4"   # Latest Amazon Linux 2023
  instance_type               = "t3.micro"

  key_name                    = aws_key_pair.example.key_name

  subnet_id                   = data.aws_subnet.public_subnet_1.id

  vpc_security_group_ids       = [data.aws_security_group.my_sg.id]

  associate_public_ip_address  = true

  tags = {
    Name = "SQL Runner"
  }
}

resource "null_resource" "remote_sql_exec" {

  depends_on = [
    aws_instance.sql_runner
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:/Users/SHAIK MAHAMMAD SAMI/.ssh/id_ed25519")
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "../local-execuation/init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {

    inline = [

      "sudo yum install mariadb105 -y",

      "sleep 60",

      "mysql -h ${data.aws_db_instance.rds.address} -P 3306 -u admin -p'Shaiksami123' sami < /tmp/init.sql"

    ]
  }

  triggers = {
    always_run = timestamp()
  }
}