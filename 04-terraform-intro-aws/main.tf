resource "aws_s3_bucket" "website_bucket" {
  bucket = "m2dfs-25-website-bucket-bng"
  region = var.aws_region
  tags = {
    Name        = "My Website bucket BNG"
    Environment = "Dev"
  }
}