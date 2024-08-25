terraform {
  backend "s3" {
    key            = "data-stores/mysql/terraform.tfstate"
    bucket         = "terraform-baby-state-prod"
    region         = "us-west-2"
    dynamodb_table = "terraform-baby-locking"
    encrypt        = true
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-baby-state-prod"
    key    = "vpc/terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_db_subnet_group" "db_sg" {
  name       = "terraform_db_subnet_group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}

resource "aws_db_instance" "db_instance" {
  identifier_prefix   = "terraform"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  db_name             = "baby"

  db_subnet_group_name = aws_db_subnet_group.db_sg.name

  username = var.db_username
  password = var.db_password
}
