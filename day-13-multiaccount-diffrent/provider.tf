/*
Multi-account + region configuration notes:

- This file declares two AWS provider configurations so Terraform can manage
	resources across multiple AWS accounts/regions from the same configuration.

- Each provider block uses `alias` to create a distinct provider instance
	(for example, `aws.dev-account` and `aws.test-account`).

- `profile` is the named profile from your AWS CLI credentials file
	(e.g. ~/.aws/credentials). It must be a string: profile = "dev".

- `region` determines which AWS region resources created with that provider
	will be placed in. Resources inherit the region from the provider unless
	explicitly overridden in the resource configuration.

- To assign a specific provider to a resource, use the `provider` argument:
		resource "aws_s3_bucket" "example" {
			provider = aws.dev-account
			bucket   = "my-bucket-dev"
		}

	or, when using alias in the block form:
		resource "aws_s3_bucket" "example" {
			provider = aws.test-account
			bucket   = "my-bucket-test"
		}

- Best practices:
	- Use distinct named CLI profiles or assume_role configurations per account.
	- Prefer passing profile/region via variables for reuse across environments.
	- Keep provider blocks minimal and explicit to avoid confusion.
*/

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