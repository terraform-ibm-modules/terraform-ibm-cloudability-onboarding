variable "bucket_crn" {
  type        = string
  description = "crn of the cos bucket. Required if policy_granularity is `resource` or `instance`"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "The resource group that the cos buckets are deployed in. Required if `policy_granularity` is \"resource-group\". Not used otherwise."
  default     = null
}

variable "policy_granularity" {
  type        = string
  description = "Whether access to the cos bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup). Note: `resource_group_id` is required in the case of the `resourceGroup`. `bucket_crn` is required otherwise. "
  default     = "resource"
  validation {
    condition     = contains(["resource", "serviceInstance", "resourceGroup"], var.policy_granularity)
    error_message = "Invalid policy_granularity: use one of \"resource\", \"serviceInstance\", or \"resourceGroup\""
  }
}

variable "cloudability_custom_role_name" {
  type        = string
  description = "name of the custom role created access granted to cloudability service id to read from the billing reports cos bucket"
  default     = "CloudabilityStorageCustomRole"
}
