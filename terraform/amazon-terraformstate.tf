resource "aws_iam_user" "terraform" {
  #checkov:skip=CKV_AWS_273: SSO for just me doesn't make sense
  name = "terraform"
}

resource "aws_iam_access_key" "terraform" {
  user = aws_iam_user.terraform.name
}

resource "aws_iam_user_policy" "terraform" {
  #checkov:skip=CKV_AWS_40: Users are not going to increase in a indiviual sub
  name = "StateBucketAccess"
  user = aws_iam_user.terraform.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "iam:*",
            "Resource": "${aws_iam_user.terraform.arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "${aws_s3_bucket.tfstate.arn}",
                "${aws_s3_bucket.tfstate.arn}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "terraformstate-dtm"
}

resource "aws_s3_bucket_public_access_block" "state_public_block" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_acl" "tfstate-acl" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "tfstate-versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  bucket = aws_s3_bucket.tfstate.bucket

  depends_on = [aws_s3_bucket_versioning.tfstate-versioning]

  rule {
    id = "TrimOldVersions"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 60
    }

    status = "Enabled"
  }
}