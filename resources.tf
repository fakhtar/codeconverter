# API Gateway resources

resource "aws_api_gateway_rest_api" "CodeConverter" {
  name        = "CodeConverter"
  description = "TCodeConverter demo"
}

resource "aws_api_gateway_resource" "CodeConverterResource" {
  rest_api_id = aws_api_gateway_rest_api.CodeConverter.id
  parent_id   = aws_api_gateway_rest_api.CodeConverter.root_resource_id
  path_part   = "codeconverter"
}


# lambda functions that will call the bedrock runtime library
resource "aws_lambda_function" "bedrocklambda" {
  filename         = "lambda.zip"
  function_name    = "bedrocklambda"
  role             = aws_iam_role.bedrocklambda_role.arn
  handler          = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("lambda.zip")
  runtime          = "python3.8"
  layers           = []
  timeout          = 15
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
