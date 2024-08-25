variable "aws_region" {
  description = "The AWS Region"
  type        = string
  default     = "us-west-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}
