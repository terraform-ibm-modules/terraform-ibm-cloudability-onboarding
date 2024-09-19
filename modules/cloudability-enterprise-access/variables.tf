variable "enterprise_id" {
  type        = string
  description = "Guid for the enterprise account id"
  default     = null
}

variable "cloudability_custom_role_name" {
  type        = string
  description = "name of the custom role to granting access to a cloudability service id to read the enterprise information"
  default     = "CloudabilityListAccCustomRole"
}
