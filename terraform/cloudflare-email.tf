resource "cloudflare_record" "owner" {
  zone_id = data.cloudflare_zone.declanmorris-com.zone_id
  name    = "@"
  value   = "protonmail-verification=5fd7946fe1d6d2805e006ba85c424dc623350bc7"
  type    = "TXT"
  proxied = false
}