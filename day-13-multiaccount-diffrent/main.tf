resource "aws_s3_bucket" "name" {
    bucket = "jhdbdnc"
    provider = aws.dev-account
  
}

resource "aws_s3_bucket" "s3" {
    bucket = "jecwheb"
    provider = aws.test-account
  
}