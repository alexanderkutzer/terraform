terraform {
  backend "s3" {
    bucket         = "techstarter-alexander-terraform-state"
    key            = "path/to/your-state-file.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}