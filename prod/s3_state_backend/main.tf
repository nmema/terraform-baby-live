module "s3_backend" {
  source = "git::https://github.com/nmema/terraform-baby-modules.git//services/s3_backend?ref=v0.0.1"

  aws_region  = "us-west-2"
  bucket_name = "terraform-baby-state-prod"
  table_name  = "terraform-baby-locking"
}

# Comment this line if S3 backend is not created.
terraform {
  backend "s3" {
    key            = "s3_state_backend/terraform.tfstate"
    bucket         = "terraform-baby-state-prod"
    region         = "us-west-2"
    dynamodb_table = "terraform-baby-locking"
    encrypt        = true
  }
}
