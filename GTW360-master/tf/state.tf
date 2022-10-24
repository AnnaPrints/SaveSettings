resource "aws_s3_bucket" "terraform_state" {
  bucket = "jb-gtw360-tfstate"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    owner = "ernst.haagsman@jetbrains.com"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "jb-gtw360-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    owner = "ernst.haagsman@jetbrains.com"
  }
}
