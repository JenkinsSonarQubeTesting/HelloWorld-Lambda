terraform {
  backend "s3" {
    bucket                  = "research-veraform-remote-state-s3"
    key                     = "carter-test/ExampleLambda/terraform.tfstate"
    region                  = "us-east-1"
    encrypt                 = true
    dynamodb_table          = "research-veraform-state-lock-dynamo"
  }
  required_version = ">= 0.11.4"
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_user_ID}:role/${var.role_name}"
  }
  region = "${var.region}"
  version = ">= 1.11.0"
}

resource "aws_security_group" "terraform-test" {
  name        = "${var.group}-${var.name}"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.group}-${var.name}"
  }
}

module "Example_IAM" {
  source = "../../Modules/IAMRole"
  group = "${var.group}"
  name = "${var.name}"
}

/*
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.group}-${var.name}"

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
*/

module "Example_Lambda" {
  source = "../../Modules/LambdaFunction"
  group = "${var.group}"
  name = "${var.name}"
  release_version = "${var.version}"
  role = "${module.Example_IAM.role_arn}"
  handler_class = "${var.handler_class}"
}

/*
resource "aws_lambda_function" "test_lambda" {
  s3_bucket        = "carter-jenkins-test-bucket"
  s3_key           = "${var.group}/${var.name}/${var.name}.${var.version}/${var.name}-${var.version}.zip"
  function_name    = "${var.group}-${var.name}"
  role             = "${module.Example_IAM.role_arn}"
  handler          = "${var.handler_class}"
  runtime          = "java8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
*/
