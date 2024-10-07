variable "cloudflare_zone_id" {
  description = "ID of cloudflare zone to add the DNS records to"
  type        = string
}

variable "verifications" {
  description = "Map of name-value pairs to be put into a TXT record"
  type        = map(string)
  default     = {}
}

variable "spf_mechanisms" {
  description = "List of SPF mechanism values to be used the SPF record"
  type        = list(string)
  default     = []
}

variable "mail_servers" {
  description = "List of mail server configurations"
  type        = list(object({ priority = string, value = string }))
  default     = []
}

variable "dkim_records" {
  description = "List of DKIM records"
  type        = list(object({ name = string, value = string }))
  default     = []
}

variable "dmarc_policy" {
  description = "Value for DMARC policy"
  type        = string
  default     = "quarantine"
  validation {
    condition     = can(regex("^none$|^quarantine$|^reject$", var.dmarc_policy))
    error_message = "DMARC policy must be one of none/quarantine/reject."
  }
}
