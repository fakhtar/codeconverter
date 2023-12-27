
# lambda functions that will call the bedrock runtime library
resource "aws_lambda_function" "bedrocklambda" {
  filename         = "lambda.zip"
  function_name    = "bedrocklambda"
  role             = aws_iam_role.bedrocklambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime          = "python3.8"
  layers           = []
}

resource "aws_iam_role" "bedrocklambda_role" {
  name = "bedrocklambda-role-githubactions"
  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Sid" : "VisualEditor0",
            "Effect" : "Allow",
            "Action" : [
              "bedrock:InvokeAgent",
              "bedrock:InvokeModel",
              "bedrock:InvokeModelWithResponseStream"
            ],
            "Resource" : "arn:aws:bedrock:*::foundation-model/*"
          }
        ]
      }
    )
  }
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