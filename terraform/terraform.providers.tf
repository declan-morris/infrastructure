provider "aws" {
  region = "eu-west-2"
}

provider "proxmox" {
  pm_tls_insecure = true
}