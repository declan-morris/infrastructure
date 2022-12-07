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

# resource "cloudflare_list" "redirectwww_to_apex" {
#   account_id  = var.CLOUDFLARE_ACCOUNT_ID
#   name        = "redirectwww_to_apex"
#   description = "Redirects www to @"
#   kind        = "redirect"

#   item {
#     value {
#       redirect {
#         source_url            = "www.declan.com/"
#         target_url            = "https://declanmorris.com"
#         include_subdomains    = "enabled"
#         subpath_matching      = "enabled"
#         status_code           = 301
#         preserve_query_string = "enabled"
#         preserve_path_suffix  = "disabled"
#       }
#     }
#   }
# }

# resource "cloudflare_ruleset" "redirectwww_to_apexRule" {
#   account_id  = var.CLOUDFLARE_ACCOUNT_ID
#   name        = "redirects"
#   description = "Redirect ruleset"
#   kind        = "root"
#   phase       = "http_request_redirect"

#   rules {
#     action = "redirect"
#     action_parameters {
#       from_list {
#         name = cloudflare_list.redirectwww_to_apex.name
#         key  = "http.request.full_uri"
#       }
#     }

#     expression  = format("http.request.full_uri in $%s", cloudflare_list.redirectwww_to_apex.name)
#     description = "Apply redirects from ${cloudflare_list.redirectwww_to_apex.name}"
#     enabled     = true
#   }
# }
