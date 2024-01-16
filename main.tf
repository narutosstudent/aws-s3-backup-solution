terraform {

  cloud {
    organization = "{organization}"
    workspaces {
      name = "{workspace}"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}


resource "aws_s3_bucket" "backup_bucket" {
  bucket = "{bucket_name}"
}

resource "aws_s3_bucket_lifecycle_configuration" "backup_lifecycle_configuration" {
  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    id     = "backup_rule"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "backup_bucket_ownership_controls" {
  bucket = aws_s3_bucket.backup_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred" # This means that if someone else uploads a file to your bucket, you, as the bucket owner, will become the owner of that file.
  }
}

resource "aws_s3_bucket_acl" "backup_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.backup_bucket_ownership_controls]

  bucket = aws_s3_bucket.backup_bucket.id
  acl    = "private" # private since this is sensitive data considered as backup
}

resource "aws_s3_bucket_versioning" "backup_bucket_versioning" {
  bucket = aws_s3_bucket.backup_bucket.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.backup_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
