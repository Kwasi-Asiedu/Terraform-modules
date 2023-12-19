terraform {
  backend "s3" {
    bucket         = "cloudrock-bucket"
    key            = "key/terraform.tfstate"
    encrypt        = true
    region         = "eu-west-2"
    dynamodb_table = "test"
  }
}