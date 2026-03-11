terraform {
  backend "s3" {
    bucket         = "im-terraform-backend-state-12345"
    key            = "terraform/aws-infra.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}