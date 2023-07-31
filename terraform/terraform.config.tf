terraform {
  required_version = ">= 1.0.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
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
      version = "~> 4.11"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.4"
    }

    http = {
      version = "~> 2.1"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.2"
    }
  }
}