 terraform {
  backend "s3" {
    bucket         = "terraform-flask"  
    key            = "test1/terraform.tfstate"  
    region         = "us-west-2"                          
    encrypt        = true                          
  }
}
