terraform {
  backend "s3" {
    bucket         = "sami-terraform-state-bucket-12345"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
  }
}
