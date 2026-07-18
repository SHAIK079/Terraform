resource "aws_iam_user" "ec2_user" {
    name = "terraform-user"
}

resource "aws_iam_group" "my_group" {
    name = "deveploer"

  
}

resource "aws_iam_user_group_membership" "user_membership" {
  user = aws_iam_user.ec2_user.name

  groups = [
    aws_iam_group.my_group.name
  ]
}

resource "aws_iam_policy" "s3_readonly" {

  name        = "S3ReadOnlyPolicy"
  description = "Allow read access to S3"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "attachment" {
  group      = aws_iam_group.my_group.name
  policy_arn = aws_iam_policy.s3_readonly.arn
}

resource "aws_iam_role" "ec2_role" {

  name = "ec2-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "profile" {

  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "my_instance" {
  ami           = "ami-01edba92f9036f76e"
  instance_type = "t3.micro"
  tags = {
    name = "ec2-profile"
  }
    
  
}