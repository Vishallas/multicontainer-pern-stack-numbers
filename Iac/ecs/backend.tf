terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "multicontainer-remote-bucket"
    key            = "ecs/terraform.tfstate"
    region         = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "multicontainer-remote-table"
    encrypt        = true
  }
}