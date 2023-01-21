terraform {
  backend "s3" {
    bucket = "terraformstate-dtm"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}