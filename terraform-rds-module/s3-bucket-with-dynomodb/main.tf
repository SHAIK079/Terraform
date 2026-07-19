resource "aws_s3_bucket" "tf_state" {
  bucket = "sami-terraform-state-bucket-12345"

  tags = {
    Name = "Terraform State"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_lock" {

  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "demo" {

  ami           = "ami-01edba92f9036f76e"

  instance_type = "t3.micro"

  tags = {
    Name = "LockDemo"
  }
}