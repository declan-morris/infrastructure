resource "cloudflare_record" "owner" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "@"
  value   = "protonmail-verification=5fd7946fe1d6d2805e006ba85c424dc623350bc7"
  type    = "TXT"
}

variable "mx_records" {
  type        = map(number)
  description = "MX Records for proton mail"
  default = {
    "mail.protonmail.ch"    = 10
    "mailsec.protonmail.ch" = 20
  }
}

resource "cloudflare_record" "mx" {
  for_each = var.mx_records
  zone_id  = data.cloudflare_zone.declanmorris-com.zone_id
  name     = "@"
  value    = each.key
  type     = "MX"
  priority = each.value
}

resource "cloudflare_record" "spf" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "@"
  value   = "v=spf1 include:_spf.protonmail.ch ~all"
  type    = "TXT"
}

variable "dkim" {
  description = "dkim for email"
  type        = map(string)
  default = {
    "protonmail"  = "protonmail.domainkey.dbba3tnvl65rdpmdar56qx5f4ifjwr5n2ksz6ndh6lwpxav66ctma.domains.proton.ch."
    "protonmail2" = "protonmail2.domainkey.dbba3tnvl65rdpmdar56qx5f4ifjwr5n2ksz6ndh6lwpxav66ctma.domains.proton.ch."
    "protonmail3" = "protonmail3.domainkey.dbba3tnvl65rdpmdar56qx5f4ifjwr5n2ksz6ndh6lwpxav66ctma.domains.proton.ch."
  }
}

resource "cloudflare_record" "dkim" {
  for_each = var.dkim
  zone_id  = data.cloudflare_zone.declanmorris-com.zone_id
  name     = "${each.key}.declanmorris.com" #change this
  value    = each.value
  type     = "CNAME"
}
