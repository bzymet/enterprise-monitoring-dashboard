resource "aws_s3_bucket" "terraform_test_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform Test Bucket"
    Environment = "Lab"
    CreatedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_test_bucket_block" {
  bucket = aws_s3_bucket.terraform_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}