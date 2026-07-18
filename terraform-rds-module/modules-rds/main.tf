resource "aws_db_instance" "rds" {

  identifier = var.identifier

  engine = var.engine

  engine_version = var.engine_version

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  db_name = var.db_name

  username = var.username

  password = var.password

  publicly_accessible = var.publicly_accessible

  skip_final_snapshot = var.skip_final_snapshot
}