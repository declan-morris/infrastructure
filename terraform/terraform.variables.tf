variable "localSubnet" {
  description = "Subnet for home network"
  default     = "192.168.86.1/24"
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  description = "value"
  sensitive   = true
}