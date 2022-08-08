data "cloudflare_zone" "dmdcZone" {
  name = "declan-morris.com"
}

resource "cloudflare_record" "dmdcRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "www"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = false #todo set to true 
}

resource "cloudflare_record" "dmdcRootRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "@"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "dmdcWildcardRecord" {
  zone_id = data.cloudflare_zone.dmdcZone.zone_id
  name    = "*"
  value   = azurerm_public_ip.pubIP.ip_address
  type    = "A"
  proxied = false
}