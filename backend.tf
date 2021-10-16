terraform {
  backend "s3" {
   bucket = "atchaya-zoominfo-testing"
   key = "terraform/terraform.state"
   encrypt = "true"
   region = "us-west-2"
 }
}
