resource "aws_iam_user" "terraform" {
  #checkov:skip=CKV_AWS_273: SSO for just me doesn't make sense
  name = "terraform"
}

resource "aws_iam_access_key" "terraform" {
  user = aws_iam_user.terraform.name
}

resource "aws_iam_user_policy" "terraform" {
  name = "StateBucketAccess"
  user = aws_iam_user.terraform.name
  # checkov:skip=CKV_AWS_40:User/role management not an issue on small personal aws

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "s3:ListBucket",
            "s3:Get*"
          ],
          "Resource": "${aws_s3_bucket.tfstate.arn}"
        },
        {
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject"
          ],
          "Resource": "${aws_s3_bucket.tfstate.arn}/*"
        }
    ]
}
EOF
}
resource "aws_iam_user_policy" "keyCreation" {
  name = "KeyCreation"
  user = aws_iam_user.terraform.name
  # checkov:skip=CKV_AWS_40:User/role management not an issue on small personal aws
  # checkov:skip=CKV_AWS_355: I think kms:CreateKey here requires * access? Not 100% sure.

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "kms:CreateKey"
          ],
          "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "keyManagement" {
  name = "KeyManagement"
  user = aws_iam_user.terraform.name
  # checkov:skip=CKV_AWS_40:User/role management not an issue on small personal aws

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "kms:DescribeKey",
            "kms:GetKeyPolicy",
            "kms:GetKeyRotationStatus",
            "kms:ListResourceTags",
            "kms:ScheduleKeyDeletion",
            "kms:GenerateDataKey",
            "kms:Decrypt",
            "kms:EnableKeyRotation"
          ],
          "Resource": "${aws_kms_key.tfstate.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "iam" {
  # checkov:skip=CKV_AWS_40:User/role management not an issue on small personal aws
  name = "IAMManagement"
  user = aws_iam_user.terraform.name


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "iam:GetUser",
            "iam:ListAccessKeys",
            "iam:GetUserPolicy"
          ],
          "Resource": "${aws_iam_user.terraform.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "UserPolicy" {
  count = var.iam ? 1 : 0
  # checkov:skip=CKV_AWS_289:Turned off outside of dev
  # checkov:skip=CKV_AWS_286:Turned off outside of dev

  name = "EditUserPolicy"
  user = aws_iam_user.terraform.name
  # checkov:skip=CKV_AWS_40:User/role management not an issue on small personal aws
  # checkov:skip=CKV_AWS_355: I think kms:CreateKey here requires * access? Not 100% sure.

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
            "iam:PutUserPolicy",
            "iam:DeleteUserPolicy"
          ],
          "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_kms_key" "tfstate" {
  description             = "This key is used to encrypt terraform state bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  # checkov:skip=CKV2_AWS_64:Not defining a kms policy
}

resource "aws_s3_bucket" "tfstate" {
  bucket = "terraformstate-dtm"
  # checkov:skip=CKV_AWS_18:Don't want to start infinite log buckets
  # checkov:skip=CKV_AWS_144:Replication will not be enabled for the state file
  # checkov:skip=CKV2_AWS_62:Don't want notifications
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfstate.arn
      sse_algorithm     = "aws:kms"
    }
  }
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

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    status = "Enabled"
  }
}