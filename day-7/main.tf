# Create Amazon S3 Bucket

resource "aws_s3_bucket" "my_bucket" {
  bucket = "kldvnfuef"

  tags = {
    Name        = "My Bucket"
    Environment = "Dev"
  }
}

# Upload Lambda ZIP to S3

resource "aws_s3_object" "my_object" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "lambda.zip"
  source = "lambda.zip"

  etag = filemd5("lambda.zip")
}

# Create IAM Role for Lambda


resource "aws_iam_role" "lambda_role" {
  name = "sami_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}


# Attach Lambda Basic Execution Policy

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create CloudWatch Log Group

resource "aws_cloudwatch_log_group" "my_log_group" {
  name              = "/aws/lambda/my_lambda_function"
  retention_in_days = 7
}

# Create Lambda Function

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"

  s3_bucket = aws_s3_bucket.my_bucket.id
  s3_key    = aws_s3_object.my_object.key

  runtime = "python3.12"
  handler = "lambda.lambda_handler"

  role = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64sha256("lambda.zip")

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy,
    aws_cloudwatch_log_group.my_log_group
  ]
}



# Create EventBridge Schedule Rule

resource "aws_cloudwatch_event_rule" "my_event_rule" {
  name                = "my_event_rule"
  description         = "Trigger Lambda every 5 minutes"
  schedule_expression = "rate(5 minutes)"
}

# EventBridge Rule with Lambda


resource "aws_cloudwatch_event_target" "my_event_target" {
  rule      = aws_cloudwatch_event_rule.my_event_rule.name
  target_id = "LambdaTarget"
  arn       = aws_lambda_function.my_lambda.arn
}


# Allow EventBridge to invoke functiond

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name

  principal  = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.my_event_rule.arn
}