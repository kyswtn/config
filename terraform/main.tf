terraform {
  cloud {}

  required_providers {
    porkbun = {
      source  = "kyswtn/porkbun"
      version = "~> 0.1"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

provider "porkbun" {
  api_key        = var.porkbun_api_key
  secret_api_key = var.porkbun_secret_api_key
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Link to Cloudflare account.
data "cloudflare_accounts" "account" {
  name = var.cloudflare_account_name
}

# Create a Cloudflare zone.
resource "cloudflare_zone" "zone" {
  account_id = data.cloudflare_accounts.account.accounts[0].id
  zone       = var.porkbun_domain_name
}

# Point nameservers of Porkbun domain to Cloudflare's.
resource "porkbun_nameservers" "nameservers" {
  domain      = var.porkbun_domain_name
  nameservers = cloudflare_zone.zone.name_servers
}

# Create R2 bucket (pointing to cdn subdomain) for storing assets.
#
# Cloudflare's terraform provider doesn't support configuring CNAME & CORS policy
# for R2 buckets, do that manually for now.
resource "cloudflare_r2_bucket" "cdn" {
  account_id = data.cloudflare_accounts.account.accounts[0].id
  name       = "cdn-${replace(var.porkbun_domain_name, ".", "-")}"
}

# Point root A to Vercel.
resource "cloudflare_record" "vercel-dns-a" {
  zone_id = cloudflare_zone.zone.id
  type    = "A"
  name    = "@"
  content = "76.76.21.21"
}

# Point www CNAME to Vercel DNS.
resource "cloudflare_record" "vercel-dns-cname" {
  zone_id = cloudflare_zone.zone.id
  type    = "CNAME"
  name    = "www"
  content = "cname.vercel-dns.com."
}

# For now, this block is for configuring Proton Mail. But this is actually meant to be 
# general-purpose and shared, because there can only be one SPF record for example.
module "dns" {
  source             = "./modules/cloudflare_common_dns"
  cloudflare_zone_id = cloudflare_zone.zone.id

  verifications = {
    "protonmail-verification" = "b3b33026ae7e42c8311de77ac43443fe6c773144"
  }
  spf_mechanisms = [
    "include:_spf.protonmail.ch"
  ]
  mail_servers = [
    { priority = 10, value = "mail.protonmail.ch" },
    { priority = 20, value = "mailsec.protonmail.ch" }
  ]
  dkim_records = [
    {
      name  = "protonmail._domainkey",
      value = "protonmail.domainkey.ddsxv5srh7sx2dwge3zvd3ooykavju2wjtx7trucoqfavrvwehxsq.domains.proton.ch"
    },
    {
      name  = "protonmail2._domainkey",
      value = "protonmail2.domainkey.ddsxv5srh7sx2dwge3zvd3ooykavju2wjtx7trucoqfavrvwehxsq.domains.proton.ch"
    },
    {
      name  = "protonmail3._domainkey",
      value = "protonmail3.domainkey.ddsxv5srh7sx2dwge3zvd3ooykavju2wjtx7trucoqfavrvwehxsq.domains.proton.ch"
    }
  ]
  dmarc_policy = "quarantine"
}
