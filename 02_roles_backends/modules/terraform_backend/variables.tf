variable "account_name" {
  type        = string
  description = "The name of the child account, used to generate bucket name."
}

variable "region" {
  type        = string
  description = "AWS region to create the bucket in."
  default     = "us-east-1"
}