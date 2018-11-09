terraform {
  backend "s3" {
    bucket                  = "research-veraform-remote-state-s3"
    key                     = "carter-test/terraform.tfstate"
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
  name        = "terraform-test"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-test"
  } 
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "test_lambda" {
  filename         = "/Lambda/HelloWorld/build/distributions/HelloWorld-1.0-SNAPSHOT.zip"
  function_name    = "Hello"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "example.Hello"
  source_code_hash = "${base64sha256(file("/Lambda/HelloWorld/build/distributions/HelloWorld-1.0-SNAPSHOT.zip"))}"
  runtime          = "java8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

/*
resource "aws_lambda_function" "example_lambda" {
  filename         = "/Lambda/ExampleLambda/build/distributions/ExampleLambda-1.0-SNAPSHOT.zip"
  function_name    = "Example"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "testpackage.Example"
  source_code_hash = "${base64sha256(file("/Lambda/ExampleLambda/build/distributions/ExampleLambda-1.0-SNAPSHOT.zip"))}"
  runtime          = "java8"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
*/
