provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-s3-bucket-15619846"
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket     = aws_s3_bucket.my_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.public_access, aws_s3_bucket_ownership_controls.ownership]

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": [
        "arn:aws:s3:::my-terraform-s3-bucket-15619846",
        "arn:aws:s3:::my-terraform-s3-bucket-15619846/*"
      ]
    }
  ]
}
POLICY
}
