variable "CLOUDFLARE_EMAIL_DMARC_ALERT" {
  type        = string
  description = "Email alert for dmarc on cloudflare"
}

variable "iam" {
  type        = bool
  description = "Allow terraform user to edit iam - useful for dev, turn off after"
  default     = false
}