provider "aws" {
	# Specify the named profile from your AWS CLI credentials file.
	# Quotes are required because this is a string literal, not a reference.
	profile = "dev"
	alias   = "dev-account"
	region  = "us-east-1"
}

provider "aws" {
	# Use a different named profile for the second account.
	profile = "test"
	alias   = "test-account"
	region  = "us-west-2"
}