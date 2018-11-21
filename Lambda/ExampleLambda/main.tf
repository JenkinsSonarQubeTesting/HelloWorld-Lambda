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

module "Example_SG" {
  // Private repository - Clone using SSH
  source = "git@github.com:Carter-DM/RemoteTFModules/Modules/SecurityGroup.git"
  group = "${var.group}"
  name = "${var.name}"
}

module "Example_IAM" {
  source = "git@github.com:Carter-DM/RemoteTFModules/Modules/IAMRole.git"
  group = "${var.group}"
  name = "${var.name}"
}

module "Example_Lambda" {
  source = "git@github.com:Carter-DM/RemoteTFModules/Modules/LambdaFunction.git"
  group = "${var.group}"
  name = "${var.name}"
  release_version = "${var.version}"
  role = "${module.Example_IAM.role_arn}"
  handler_class = "${var.handler_class}"
}
