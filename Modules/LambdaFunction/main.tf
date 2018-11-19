resource "aws_lambda_function" "test_lambda" {
  s3_bucket        = "carter-jenkins-test-bucket"
  s3_key           = "${var.group}/${var.name}/${var.name}.${var.version}/${var.name}-${var.version}.zip"
  function_name    = "${var.group}-${var.name}"
  role             = "${var.role}"
  handler          = "${var.handler_class}"
  runtime          = "java8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}