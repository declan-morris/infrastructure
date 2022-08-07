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

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}