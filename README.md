# Backup solution with AWS S3

# S3 Bucket Ownership Controls

When you upload a file to an Amazon S3 bucket, there's a question of who "owns" that file. In AWS, each piece of data (like a file) can have an owner, and this owner has certain rights over the file, like who can access or modify it.

## What are Ownership Controls?

Ownership controls in an S3 bucket determine who owns the files uploaded to that bucket.

## Why Use Them?

It's important when different AWS accounts are interacting with the same bucket. For instance, if someone from a different AWS account uploads a file to your bucket, you might want to be the owner of that file, so you can control its access and usage.

## Values They Accept

- **`BucketOwnerPreferred`**: This means that if someone else uploads a file to your bucket, you, as the bucket owner, will become the owner of that file.
- **`ObjectWriter`**: The uploader of the file retains ownership. This is less common and might be used in cases where the uploader needs to maintain control over the file.

# S3 Bucket ACL (Access Control List)

An Access Control List (ACL) is like a list of rules that define who can do what with your S3 bucket and the files in it.

## What is a Bucket ACL?

A Bucket ACL is a way to control access to your S3 bucket. It's like setting permissions on who can view, upload, delete, or manage the files in your bucket.

## Why Use a Bucket ACL?

You use a Bucket ACL to ensure that only authorized people or services can access or modify the contents of your S3 bucket. It's important for maintaining the security and privacy of your data stored in AWS S3.

## Values They Accept

- **`private`**: Only the bucket owner can access the bucket. This is the most restrictive setting.
- **`public-read`**: Anyone on the internet can read (but not write) the contents of the bucket. Useful for hosting public files, but be cautious with this setting due to security concerns.
- **`public-read-write`**: Anyone can read and write to the bucket. This setting is generally not recommended due to security risks.
- **`authenticated-read`**: Only authenticated AWS users (any AWS account) can read the contents of the bucket.

# S3 Bucket Versioning

Versioning in an S3 bucket is like keeping a history of all the changes made to the files in that bucket. When you enable versioning, every time you upload a file with the same name as an existing file, instead of replacing the old file, AWS S3 keeps both versions.

It's good for tracking changes and data recovery. In our case since we're using S3 for backups, we want to enable versioning so we can recover from accidental deletions or overwrites.

# S3 Bucket Server-Side Encryption

Server-side encryption is about protecting your files by encrypting them when they are stored in your S3 bucket. AWS handles the encryption and decryption automatically.

It's a feature where AWS encrypts your files when you upload them to S3 and decrypts them when you access them. This all happens on the server side (hence the name).

It's good for data protection.

`AES256`: This stands for Advanced Encryption Standard with a 256-bit key. It's a strong encryption method.

# S3 Bucket Lifecycle Configuration

A lifecycle configuration in an S3 bucket is like setting up automatic rules to manage your files over time. It tells AWS what to do with your files as they get older or meet certain conditions.

It's a set of rules that automate processes like deleting old files or moving them to cheaper storage options. This helps manage and reduce costs, especially for data that you don't need to access frequently.

In our case, we'll delete old backups after 90 days.

```
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
```
