terraform {
  backend "s3" {
    bucket         = "mycitcode"
    key            = "stage"
    dynamodb_table = "mycittest"
    region         = "us-east-1"
  }
}
