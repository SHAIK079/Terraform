terraform {
  backend "s3" {
    bucket = "terraform-state-sami-123"
    key    = "terraform.tfstate"
    region = "us-east-1"
    #use_lockfile = true ##supports terrafrom latest version >=1.10
   use_lockfile = true #if terrafrom version <1.10 use below code
    
  }
}