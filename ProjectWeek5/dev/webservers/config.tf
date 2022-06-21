terraform {
  backend "s3" {
    bucket = "devrp-acs730"   // Bucket where to SAVE Terraform State
    key    = "devrp-webservers/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}