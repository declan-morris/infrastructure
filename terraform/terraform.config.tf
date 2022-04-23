terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.0"
    }
  }
}