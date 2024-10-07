variable "porkbun_domain_name" {}
variable "porkbun_api_key" {
  sensitive = true
}
variable "porkbun_secret_api_key" {
  sensitive = true
}

variable "cloudflare_account_name" {}
variable "cloudflare_api_token" {
  sensitive   = true
  description = <<EOH
    # Required permissions
    1. Account:"Account Settings":Read
    2. Zone:Zone:Edit
    3. Zone:"Zone Settings":Edit
    4. Zone:DNS:Edit
    5. Account:"Workers R2 Storage":Edit
  EOH
}
