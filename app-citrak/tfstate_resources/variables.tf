variable "aws_profile" {}
variable "aws_region" {}



variable "s3_bucket" {
  description = "'Name' tag for S3 bucket with terraform state."
  default     =  "mycitcode"
}

variable "dynamodb_table" {
  description = "DynamoDB table name for terraform lock."
  default     =  "mycittest"
}
