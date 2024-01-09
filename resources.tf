# API Gateway resources

resource "aws_api_gateway_deployment" "CodeConverterDeployment" {
  rest_api_id = aws_api_gateway_rest_api.CodeConverter.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.CodeConverter.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "CodeConverterDeploymentSingleStage" {
  deployment_id = aws_api_gateway_deployment.CodeConverterDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.CodeConverter.id
  stage_name    = "dev"
}

resource "aws_api_gateway_rest_api" "CodeConverter" {
  name        = "CodeConverter"
  description = "TCodeConverter demo"
}

resource "aws_api_gateway_resource" "CodeConverterResource" {
  rest_api_id = aws_api_gateway_rest_api.CodeConverter.id
  parent_id   = aws_api_gateway_rest_api.CodeConverter.root_resource_id
  path_part   = "codeconverter"
}

resource "aws_api_gateway_method" "CodeConverterPostMethod" {
  rest_api_id   = aws_api_gateway_rest_api.CodeConverter.id
  resource_id   = aws_api_gateway_resource.CodeConverterResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "CodeConverterLambdaIntegration" {
  rest_api_id             = aws_api_gateway_rest_api.CodeConverter.id
  resource_id             = aws_api_gateway_resource.CodeConverterResource.id
  http_method             = aws_api_gateway_method.CodeConverterPostMethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bedrocklambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bedrocklambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.CodeConverter.id}/*/${aws_api_gateway_method.CodeConverterPostMethod.http_method}${aws_api_gateway_resource.CodeConverterResource.path}"
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
  timeout          = 30
}

resource "aws_iam_role" "bedrocklambda_role" {
  name = "bedrocklambda-role-githubactions"
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
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
