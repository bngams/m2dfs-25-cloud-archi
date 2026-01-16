resource "aws_s3_bucket" "website_bucket" {
  bucket = "m2dfs-25-website-bucket-bng-bis"
  region = var.aws_region
  tags = {
    Name        = "My Website bucket BNG"
    Environment = "Dev"
  }
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "website_bucket_conf" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "website_bucket_index_file" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "index.html"
  source = "${path.module}/assets/index.html"
  content_type = "text/html; charset=utf-8" 
}

resource "aws_s3_object" "website_bucket_error_file" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = "error.html"
  source = "${path.module}/assets/error.html"
  content_type = "text/html; charset=utf-8" 
}

resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = <<EOT
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Sid": "PublicReadGetObject",
              "Effect": "Allow",
              "Principal": "*",
              "Action": [
                  "s3:GetObject"
              ],
              "Resource": [
                  "${aws_s3_bucket.website_bucket.arn}/*"
              ]
          }
      ]
  }
  EOT
}

resource "aws_s3_bucket_ownership_controls" "my-static-website" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Outputs for website urls
# s3 static website url
output "website_url_manual" {
  value = "http://${aws_s3_bucket.website_bucket.bucket}.s3-website.${var.aws_region}.amazonaws.com"
}

output "website_url" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}
