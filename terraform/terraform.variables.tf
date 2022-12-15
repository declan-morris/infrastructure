variable "localSubnet" {
  description = "Subnet for home network"
  default     = "192.168.86.1/24"
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  description = "Account ID for cloudflare"
  sensitive   = true
}

variable "CLOUDFLARE_EMAIL_DMARC_ALERT" {
  description = "Email alert for dmarc on cloudflare"
}