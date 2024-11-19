variable "enterprise_id" {
  type        = string
  description = "Guid for the enterprise account id"
  default     = null
}
variable "use_existing_iam_custom_role" {
  type        = bool
  description = "Whether the iam_custom_roles should be created or if they already exist and the they should be linked with a datasource"
  default     = false
}

variable "skip_cloudability_billing_policy" {
  type        = bool
  description = "Whether policy which grants cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run."
  default     = false
}

variable "cloudability_custom_role_name" {
  type        = string
  description = "Name of the custom role which grants access to the Cloudability service ID to read the enterprise information. Only used if `is_enterprise_account` is `true`."
  default     = "CloudabilityListAccCustomRole"
}
