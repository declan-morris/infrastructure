# tflint-ignore: terraform_unused_declarations
variable "localSubnet" {
  type        = string
  description = "Subnet for home network"
  default     = "192.168.86.1/24"
}

variable "CLOUDFLARE_EMAIL_DMARC_ALERT" {
  type        = string
  description = "Email alert for dmarc on cloudflare"
}