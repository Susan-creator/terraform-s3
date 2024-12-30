# Create S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketname
}

# Bucket Ownership Controls
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Public Access Block Configuration
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL for Public Access
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

# Upload index.html to the bucket
resource "aws_s3_object" "index" {
  depends_on = [aws_s3_bucket.mybucket]  # Ensure the bucket is created first
  bucket    = aws_s3_bucket.mybucket.bucket 
  key       = "index.html"
  source    = "index.html"
  acl       = "public-read"
  content_type = "text/html"
}

# Upload error.html to the bucket
resource "aws_s3_object" "error" {
  depends_on = [aws_s3_bucket.mybucket]  # Ensure the bucket is created first
  bucket    = aws_s3_bucket.mybucket.bucket  
  key       = "error.html"
  source    = "error.html"
  acl       = "public-read"
  content_type = "text/html"
}

# Upload profile.png to the bucket
resource "aws_s3_object" "profile" {
  depends_on = [aws_s3_bucket.mybucket]  # Ensure the bucket is created first
  bucket    = aws_s3_bucket.mybucket.bucket  # Correct reference
  key       = "profile.png"
  source    = "profile.png"
  acl       = "public-read"
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]
}
