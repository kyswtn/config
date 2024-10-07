terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

resource "cloudflare_record" "verifications" {
  zone_id  = var.cloudflare_zone_id
  type     = "TXT"
  name     = "@"
  for_each = var.verifications
  content  = "${each.key}=${each.value}"
}

resource "cloudflare_record" "spf" {
  zone_id = var.cloudflare_zone_id
  type    = "TXT"
  name    = "@"
  content = "v=spf1 ${join(" ", var.spf_mechanisms)} mx ~all"
}

resource "cloudflare_record" "mx" {
  zone_id = var.cloudflare_zone_id
  type    = "MX"
  name    = "@"
  for_each = {
    for _, mx in var.mail_servers :
    // Use server priority as resource name suffix here.
    mx.priority => mx.value
  }
  priority = each.key
  content  = each.value
}

resource "cloudflare_record" "dkim" {
  zone_id = var.cloudflare_zone_id
  type    = "CNAME"
  proxied = false
  for_each = {
    for _, dkim in var.dkim_records :
    // Use dkim hostname as resource name suffix here.
    dkim.name => dkim.value
  }
  name    = each.key
  content = each.value
}

resource "cloudflare_record" "dmarc" {
  zone_id = var.cloudflare_zone_id
  type    = "TXT"
  name    = "_dmarc"
  content = "v=DMARC1; p=${var.dmarc_policy}"
}
