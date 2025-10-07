terraform {
  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "wiz-exercise-tf-state-larissa-pefok"
    key            = "wiz-exercise/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "wiz-exercise-terraform-locks-larissa-pefok"
  }
}
