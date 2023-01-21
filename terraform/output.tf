output "terraformAccessKeySecret" {
  value       = aws_iam_access_key.terraform.secret
  description = "Access key secret for terraform user in aws"
  sensitive   = true
}

output "terraformAccessKeyId" {
  value       = aws_iam_access_key.terraform.id
  description = "Access key id for terraform user in aws"
  sensitive   = true
}

output "dmdcPublicIp" {
  value       = azurerm_public_ip.pubIP.ip_address
  description = "Public ip address for dmdc"
}