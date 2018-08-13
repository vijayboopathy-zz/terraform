terraform {
  backend "s3" {
    encrypt = true
    bucket = "vibes-example-terraform"
    key    = "terraform-state/terraform.tfstate"
    region = "us-east-1"
  }
}
