output "terraformAccessKeySecret" {
  value     = aws_iam_access_key.terraform.secret
  sensitive = true
}

output "terraformAccessKeyId" {
  value     = aws_iam_access_key.terraform.id
  sensitive = true
}