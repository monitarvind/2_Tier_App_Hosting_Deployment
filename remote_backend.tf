terraform {
    backend "s3" {
        bucket = "statefile-2025-06-23"
        key = "terraform/dev/terraform.dev.tfstate"
        region = "ap-south-1"
    }
}