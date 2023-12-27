
# lambda functions that will call the bedrock runtime library
resource "aws_lambda_function" "bedrocklambda" {
    filename      = "lambda.zip"
    function_name = "bedrocklambda"
    role          = aws_iam_role.bedrocklambda_role.arn
    handler       = "bedrocklambda.lambda_handler"
    source_code_hash = filebase64sha256("lambda.zip")
    runtime = "python3.8"
    layers = []
}

resource "aws_iam_role" "bedrocklambda_role" {
  name = "bedrocklambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}