variable "bucket_crn" {
  type        = string
  description = "crn of the Object Storage bucket. Required if policy_granularity is `resource` or `instance`"
  default     = null
}

variable "resource_group_id" {
  type        = string
  description = "The resource group that the cos buckets are deployed in. Required if `policy_granularity` is \"resource-group\". Not used otherwise."
  default     = null
}

variable "policy_granularity" {
  type        = string
  description = "Whether access to the Object Storage bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup). Note: `resource_group_id` is required in the case of the `resourceGroup`. `bucket_crn` is required otherwise. "
  default     = "resource"
  validation {
    condition     = contains(["resource", "serviceInstance", "resourceGroup"], var.policy_granularity)
    error_message = "Invalid policy_granularity: use one of \"resource\", \"serviceInstance\", or \"resourceGroup\""
  }
}

variable "use_existing_iam_custom_role" {
  type        = bool
  description = "Whether the iam_custom_roles should be created or if they already exist and the they should be linked with a datasource"
  default     = false
}

variable "cloudability_custom_role_name" {
  type        = string
  description = "Name of the custom role which grants access to the Cloudability service id to read the billing reports from the object storage bucket"
  default     = "CloudabilityStorageCustomRole"
}
