variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}
