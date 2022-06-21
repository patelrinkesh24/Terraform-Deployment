terraform {
  backend "s3" {
    bucket = "prodrp-acs730" // Bucket where to SAVE Terraform State
    key    = "prodrp-network/terraform.tfstate"  // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                       // Region where bucket is created
  }
}