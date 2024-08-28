data "cloudflare_zone" "dmdcZone" {
  name = "declan-morris.com"
}

resource "cloudflare_record" "dmdcRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "www"
  value   = "declanmorris.com"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "dmdcRootRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "@"
  value   = "declanmorris.com"
  type    = "CNAME"
  proxied = false
}

resource "cloudflare_record" "dmdcWildcardRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "*"
  value   = "declanmorris.com"
  type    = "CNAME"
  proxied = false
}

data "cloudflare_zone" "declanmorris-com" {
  name = "declanmorris.com"
}

resource "cloudflare_record" "declanmorris-comWWWRecord" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "www"
  value   = azurerm_public_ip.pubIP.ip_address # 192.0.2.1? to root www to apex?
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "declanmorris-comRootRecord" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "@"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "declanmorris-comWildcardRecord" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "*"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "dmarc" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "_dmarc"
  value   = "v=DMARC1; p=reject; rua=mailto:${var.CLOUDFLARE_EMAIL_DMARC_ALERT}; ruf=mailto:${var.CLOUDFLARE_EMAIL_DMARC_ALERT}; fo=1:d:s"
  type    = "TXT"
}