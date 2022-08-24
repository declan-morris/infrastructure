data "cloudflare_zone" "dmdcZone" {
  name = "declan-morris.com"
}

resource "cloudflare_record" "dmdcRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "www"
  value   = "@"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "dmdcRootRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "@"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "dmdcWildcardRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "*"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = true
}

data "cloudflare_zone" "declanmorris-com" {
  name = "declanmorris.com"
}

resource "cloudflare_record" "declanmorris-comWWWRecord" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "www"
  value   = azurerm_public_ip.pubIP.ip_address
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