variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

# region needs to provide cross region support.
variable "region" {
  description = "Region where resources are created"
  type        = string
  default     = "us-south"

  validation {
    condition     = can(regex("us-south|eu-de|jp-tok|us-east|eu-gb|au-syd|jp-osa|ca-tor|br-sao|eu-es", var.region))
    error_message = "'region' must be a Key Protect supported region. See https://cloud.ibm.com/docs/key-protect?topic=key-protect-regions"
  }
}

########################################################################################################################
# Key_protect
########################################################################################################################

variable "create_key_protect_instance" {
  type        = bool
  description = "Key Protect instance name"
  default     = true
}

variable "key_protect_instance_name" {
  type        = string
  description = "Key Protect instance name"
  default     = null
}

variable "key_ring_name" {
  type        = string
  description = "Name of the key ring to group keys"
  default     = "bucket-encryption"
}

variable "key_name" {
  type        = string
  description = "Name of the Object Storage bucket encryption key"
  default     = null
}




##############################################################################
# Common variables
##############################################################################

variable "resource_group_id" {
  type        = string
  description = "The resource group ID where resources will be provisioned."
}

##############################################################################
# COS instance variables
##############################################################################

variable "create_cos_instance" {
  description = "Set as true to create a new Cloud Object Storage instance."
  type        = bool
  default     = true
}

variable "cos_instance_name" {
  description = "The name to give the Cloud Object Storage instance that will be provisioned by this module. Only required if 'create_cos_instance' is true."
  type        = string
  default     = "billing_snapshots"
}

variable "cos_plan" {
  description = "Plan to be used for creating Cloud Object Storage instance. Only used if 'create_cos_instance' it true."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "lite", "cos-one-rate-plan"], var.cos_plan)
    error_message = "The specified cos_plan is not a valid selection!"
  }
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the cos instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []

  validation {
    condition = alltrue([
      for tag in var.access_tags : can(regex("[\\w\\-_\\.]+:[\\w\\-_\\.]+", tag)) && length(tag) <= 128
    ])
    error_message = "Tags must match the regular expression \"[\\w\\-_\\.]+:[\\w\\-_\\.]+\", see https://cloud.ibm.com/docs/account?topic=account-tag&interface=ui#limits for more details"
  }
}

variable "existing_cos_instance_id" {
  description = "The ID of an existing Cloud Object Storage instance. Required if 'var.create_cos_instance' is false."
  type        = string
  default     = null
}

##############################################################################
# Object Storage bucket variables
##############################################################################

variable "cross_region_location" {
  description = "Specify the cross-regional bucket location. Supported values are 'us', 'eu', and 'ap'. If you pass a value for this, ensure to set the value of var.region to null."
  type        = string
  default     = null

  validation {
    condition     = var.cross_region_location == null || can(regex("us|eu|ap", var.cross_region_location))
    error_message = "Variable 'cross_region_location' must be 'us' or 'eu', 'ap', or 'null'."
  }
}

variable "bucket_name" {
  type        = string
  description = "The name to give the newly provisioned Object Storage bucket."
  default     = "snapshots"
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add random generated suffix (4 characters long) to the newly provisioned Object Storage bucket name (Optional)."
  default     = false
}

variable "bucket_storage_class" {
  type        = string
  description = "the storage class of the newly provisioned Object Storage bucket. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`."
  default     = "standard"

  validation {
    condition     = can(regex("^standard$|^vault$|^cold$|^smart$|^onerate_active", var.bucket_storage_class))
    error_message = "Variable 'bucket_storage_class' must be 'standard', 'vault', 'cold', 'smart' or 'onerate_active'."
  }
}

variable "management_endpoint_type_for_bucket" {
  description = "The type of endpoint for the IBM terraform provider to use to manage the bucket. (public, private, or direct)"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private", "direct"], var.management_endpoint_type_for_bucket)
    error_message = "The specified management_endpoint_type_for_bucket is not a valid selection!"
  }
}

variable "retention_enabled" {
  description = "Retention enabled for Object Storage bucket."
  type        = bool
  default     = false
}

variable "retention_default" {
  description = "Specifies default duration of time an object that can be kept unmodified for Object Storage bucket."
  type        = number
  default     = 90
  validation {
    condition     = var.retention_default > 0 && var.retention_default < 365243
    error_message = "The specified duration for retention maximum period is not a valid selection!"
  }
}

variable "retention_maximum" {
  description = "Specifies maximum duration of time an object that can be kept unmodified for Object Storage bucket."
  type        = number
  default     = 350
  validation {
    condition     = var.retention_maximum > 0 && var.retention_maximum < 365243
    error_message = "The specified duration for retention maximum period is not a valid selection!"
  }
}

variable "retention_minimum" {
  description = "Specifies minimum duration of time an object must be kept unmodified for Object Storage bucket."
  type        = number
  default     = 90
  validation {
    condition     = var.retention_minimum > 0 && var.retention_minimum < 365243
    error_message = "The specified duration for retention minimum period is not a valid selection!"
  }
}

variable "retention_permanent" {
  description = "Specifies a permanent retention status either enable or disable for Object Storage bucket."
  type        = bool
  default     = false
}

variable "object_versioning_enabled" {
  description = "Enable object versioning to keep multiple versions of an object in a bucket."
  type        = bool
  default     = false
}

variable "archive_days" {
  description = "Specifies the number of days when the archive rule action takes effect. This must be set to null when when using var.cross_region_location as archive data is not supported with this feature."
  type        = number
  default     = null
}

variable "archive_type" {
  description = "Specifies the storage class or archive type to which you want the object to transition."
  type        = string
  default     = "Glacier"
  validation {
    condition     = contains(["Glacier", "Accelerated"], var.archive_type)
    error_message = "The specified archive_type is not a valid selection!"
  }
}

variable "expire_days" {
  description = "Specifies the number of days when the expire rule action takes effect."
  type        = number
  default     = null
}

variable "activity_tracker_read_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_write_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket write events (uploads) will be sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_management_events" {
  type        = bool
  description = "If set to true, all Object Storage management events will be sent to Activity Tracker."
  default     = true
}

variable "monitoring_crn" {
  type        = string
  description = "The CRN of an IBM Cloud Monitoring instance to send Object Storage bucket metrics to. If no value passed, metrics are sent to the instance associated to the container's location unless otherwise specified in the Metrics Router service configuration."
  default     = null
}


variable "request_metrics_enabled" {
  type        = bool
  description = "If set to `true`, all Object Storage bucket request metrics will be sent to the monitoring service."
  default     = true
}

variable "usage_metrics_enabled" {
  type        = bool
  description = "If set to `true`, all Object Storage bucket usage metrics will be sent to the monitoring service."
  default     = true
}

variable "existing_kms_instance_crn" {
  type        = string
  description = "The CRN of an existing Key Protect or Hyper Protect Crypto Services instance. Required if 'create_key_protect_instance' is false."
  default     = null
}

variable "key_protect_allowed_network" {
  type        = string
  description = "The type of the allowed network to be set for the Key Protect instance. Possible values are 'private-only', or 'public-and-private'. Only used if 'create_key_protect_instance' is true."
  default     = "public-and-private"
  validation {
    condition     = can(regex("private-only|public-and-private", var.key_protect_allowed_network))
    error_message = "The key_protect_allowed_network value must be 'private-only' or 'public-and-private'."
  }
}

variable "key_ring_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for creating key rings. Accepts 'public' or 'private'"
  default     = "public"
  validation {
    condition     = can(regex("public|private", var.key_ring_endpoint_type))
    error_message = "The endpoint_type value must be 'public' or 'private'."
  }
}

variable "key_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for creating keys. Accepts 'public' or 'private'"
  default     = "public"
  validation {
    condition     = can(regex("public|private", var.key_endpoint_type))
    error_message = "The endpoint_type value must be 'public' or 'private'."
  }
}

variable "rotation_enabled" {
  type        = bool
  description = "If set to true, Key Protect enables a rotation policy on the Key Protect instance. Only used if 'create_key_protect_instance' is true."
  default     = true
}

variable "rotation_interval_month" {
  type        = number
  description = "Specifies the number of months for the encryption key to be rotated.. Must be between 1 and 12 inclusive. Only used if 'create_key_protect_instance' is true."
  default     = 1
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance in `existing_kms_instance_crn`. WARNING: An authorization policy must exist before an encrypted bucket can be created"
  default     = false
}
