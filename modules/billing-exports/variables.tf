########################################################################################################################
# Input Variables
########################################################################################################################

variable "billing_account_id" {
  type        = string
  description = "Account id which billing exports are enabled in. Defaults to the account id of the api key"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "resource_group_id for the polcicy creation of the service to service authorization"
  default     = null
}

variable "cos_bucket_crn" {
  type        = string
  description = "CRN of the COS bucket"
}

variable "cos_bucket_location" {
  type        = string
  description = "location of the cos bucket"
}

variable "interval" {
  type        = string
  description = "Billing granularity"
  default     = "daily"
}

variable "cos_folder" {
  type        = string
  description = "Folder in the COS bucket to store the account data"
  default     = "IBMCloud-Billing-Reports"
}

variable "report_types" {
  type        = list(string)
  description = "billing report types"
  default     = null
}

variable "versioning" {
  type        = string
  description = "Add new reports or overwrite existing reports"
  default     = "overwrite"
}

variable "skip_authorization_policy" {
  type        = bool
  description = "Whether to skip the authorization policy. May be used when deploying across accounts."
  default     = false
}
