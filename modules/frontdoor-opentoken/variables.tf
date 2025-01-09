########################################################################################################################
# Input Variables
########################################################################################################################

variable "host" {
  type        = string
  description = "Frontdoor application host name"
  default     = "https://frontdoor.apptio.com"
}


variable "key" {
  type        = string
  description = "The api key id from frontdoor"
}

variable "secret" {
  type        = string
  description = "The api key secret from frontdoor"
  sensitive   = true
}
