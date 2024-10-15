
variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key which will enable billing exports"
  sensitive   = true
}

variable "cloudability_api_key" {
  type        = string
  description = "Cloudability API Key. Retrieve your Api Key from https://app.apptio.com/cloudability#/settings/preferences under the section **Cloudability API** select **Enable API** which will generate an api key. Setting this value to __NULL__ will skip adding the IBM Cloud account to Cloudability and only configure IBM Cloud so that the IBM Cloud Account can be added to Cloudability manually"
  sensitive   = true
  default     = null
}

variable "is_enterprise_account" {
  type        = bool
  description = "Whether billing exports are enabled for the enterprise account"
  default     = false
}

variable "enterprise_id" {
  type        = string
  description = "Id of the enterprise. Can be automatically retrieved if `is_enterprise_account` is true"
  default     = null
  validation {
    condition     = var.enterprise_id != null ? can(regex("^[0-9a-f]{32}$", var.enterprise_id)) : true
    error_message = "Must be a valid enterprise id"
  }
}

variable "enable_billing_exports" {
  type        = bool
  description = "Whether billing exports should be enabled"
  default     = true
}

variable "policy_granularity" {
  type        = string
  description = "Whether access to the cos bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup)."
  default     = "resource"
  validation {
    condition     = contains(["resource", "serviceInstance", "resourceGroup"], var.policy_granularity)
    error_message = "Invalid policy_granularity: use one of \"resource\", \"serviceInstance\", or \"resourceGroup\""
  }
}

##############################################################################
# Common variables
##############################################################################

variable "use_existing_resource_group" {
  type        = bool
  description = "Whether the value of `resource_group_name` input should be a new of existing resource_group"
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision resources in to."
  default     = "Default"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_ ]+$", var.resource_group_name)) && length(var.resource_group_name) < 40
    error_message = "Must be a valid resource group name that matches ^[a-zA-Z0-9-_ ]+$ and be less than 40 characters"
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
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

# region needs to provide cross region support.
variable "region" {
  description = "Region where resources will be created"
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
  default     = "cloudability-bucket-encryption"
  validation {
    condition     = can(regex("^([^[:ascii:]]|[a-zA-Z0-9-._: ])+$", var.key_protect_instance_name)) && length(var.key_protect_instance_name) < 180
    error_message = "must be a valid resource instance name"
  }
}

variable "key_ring_name" {
  type        = string
  description = "Name of the key ring to group keys"
  default     = "bucket-encryption"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,100}$", var.key_ring_name))
    error_message = "Possible values: 2 ≤ length ≤ 100, Value must match regular expression ^[a-zA-Z0-9-]{2,100}$"
  }

}

variable "key_name" {
  type        = string
  description = "Name of the cos bucket encryption key"
  default     = null
  validation {
    condition     = var.key_name != null ? can(regex("^[a-zA-Z0-9-_]{2,90}$", var.key_name)) : true
    error_message = "Possible values: 2 ≤ length ≤ 90, Value must match regular expression ^[a-zA-Z0-9-]{2,90}$"
  }

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
  description = "The name to give the cloud object storage instance that will be provisioned by this module. Only required if 'create_cos_instance' is true."
  type        = string
  default     = "ibm-cloudability"
  validation {
    condition     = can(regex("^([^[:ascii:]]|[a-zA-Z0-9-._: ]){0,179}$", var.cos_instance_name))
    error_message = "must be a valid resource instance name"
  }
}

variable "cos_plan" {
  description = "Plan to be used for creating cloud object storage instance. Only used if 'create_cos_instance' it true."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "lite", "cos-one-rate-plan"], var.cos_plan)
    error_message = "The specified cos_plan is not a valid selection!"
  }
}

variable "existing_cos_instance_id" {
  description = "The ID of an existing cloud object storage instance. Required if 'var.create_cos_instance' is false."
  type        = string
  default     = null

  validation {
    condition     = var.existing_cos_instance_id != null ? can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.existing_cos_instance_id)) : true
    error_message = "must be a valid cos instance id"
  }
}

##############################################################################
# COS bucket variables
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
  description = "The name to give the newly provisioned COS bucket. Only required if 'create_cos_bucket' is true."
  default     = "apptio-cldy-billing-snapshots"
  validation {
    condition     = can(regex("^[a-z][0-9a-z\\.\\-]{1,57}$", var.bucket_name))
    error_message = "must be a valid bucket name between 3 and 58 characters long and composed of lowercase letters, numbers, dots (periods) or dashes (hyphens). Bucket names must begin and end with a lowercase letter or number. see https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-compatibility-api-bucket-operations#compatibility-api-new-bucket"
  }
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add random generated suffix (4 characters long) to the newly provisioned COS bucket name (Optional)."
  default     = true
}

variable "bucket_storage_class" {
  type        = string
  description = "the storage class of the newly provisioned COS bucket. Only required if 'create_cos_bucket' is true. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`."
  default     = "standard"

  validation {
    condition     = can(regex("^standard$|^vault$|^cold$|^smart$|^onerate_active", var.bucket_storage_class))
    error_message = "Variable 'bucket_storage_class' must be 'standard', 'vault', 'cold', 'smart' or 'onerate_active'."
  }
}

variable "management_endpoint_type_for_bucket" {
  description = "The type of endpoint for the IBM terraform provider to use to manage the bucket. (public, private or direct)"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private", "direct"], var.management_endpoint_type_for_bucket)
    error_message = "The specified management_endpoint_type_for_bucket is not a valid selection!"
  }
}

variable "retention_enabled" {
  description = "Retention enabled for COS bucket. Only used if 'create_cos_bucket' is true."
  type        = bool
  default     = false
}

variable "retention_default" {
  description = "Specifies default duration of time an object that can be kept unmodified for COS bucket. Only used if 'create_cos_bucket' is true."
  type        = number
  default     = 90
  validation {
    condition     = var.retention_default > 0 && var.retention_default < 365243
    error_message = "The specified duration for retention maximum period is not a valid selection!"
  }
}

variable "retention_maximum" {
  description = "Specifies maximum duration of time an object that can be kept unmodified for COS bucket. Only used if 'create_cos_bucket' is true."
  type        = number
  default     = 365
  validation {
    condition     = var.retention_maximum > 0 && var.retention_maximum < 365243
    error_message = "The specified duration for retention maximum period is not a valid selection!"
  }
}

variable "retention_minimum" {
  description = "Specifies minimum duration of time an object must be kept unmodified for COS bucket. Only used if 'create_cos_bucket' is true."
  type        = number
  default     = 1
  validation {
    condition     = var.retention_minimum > 0 && var.retention_minimum < 365243
    error_message = "The specified duration for retention minimum period is not a valid selection!"
  }
}

variable "retention_permanent" {
  description = "Specifies a permanent retention status either enable or disable for COS bucket. Only used if 'create_cos_bucket' is true."
  type        = bool
  default     = false
}

variable "object_versioning_enabled" {
  description = "Enable object versioning to keep multiple versions of an object in a bucket. Cannot be used with retention rule. Only used if 'create_cos_bucket' is true."
  type        = bool
  default     = false
}

variable "archive_days" {
  description = "Specifies the number of days when the archive rule action takes effect. Only used if 'create_cos_bucket' is true. This must be set to null when when using var.cross_region_location as archive data is not supported with this feature."
  type        = number
  default     = null
}

variable "archive_type" {
  description = "Specifies the storage class or archive type to which you want the object to transition. Only used if 'create_cos_bucket' is true."
  type        = string
  default     = "Glacier"
  validation {
    condition     = contains(["Glacier", "Accelerated"], var.archive_type)
    error_message = "The specified archive_type is not a valid selection!"
  }
}

variable "expire_days" {
  description = "Specifies the number of days when the expire rule action takes effect. Only used if 'create_cos_bucket' is true."
  type        = number
  default     = null
}

variable "activity_tracker_crn" {
  type        = string
  description = "The CRN of an Activity Tracker instance to send Object Storage bucket events to. If no value passed, events are sent to the instance associated to the container's location unless otherwise specified in the Activity Tracker Event Routing service configuration."
  default     = null
  validation {
    condition     = var.activity_tracker_crn != null ? can(regex("crn:v1:bluemix:public:logdnaat:(in-che|jp-tok|jp-osa|ca-tor|br-sao|au-syd|eu-gb|eu-es|us-south|eu-de|us-east):a/[0-9a-f]{32}:[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}::", var.activity_tracker_crn)) : true
    error_message = "Must be a valid activity tracker crn"
  }
}

variable "activity_tracker_read_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket read events (i.e. downloads) will be sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_write_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket write events (i.e. uploads) will be sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_management_events" {
  type        = bool
  description = "If set to true, all Object Storage management events will be sent to Activity Tracker. Only applies if `activity_tracker_crn` is not populated."
  default     = true
}

variable "monitoring_crn" {
  type        = string
  description = "The CRN of an IBM Cloud Monitoring instance to to send Object Storage bucket metrics to. If no value passed, metrics are sent to the instance associated to the container's location unless otherwise specified in the Metrics Router service configuration."
  default     = null
  validation {
    condition     = var.monitoring_crn != null ? can(regex("crn:v1:bluemix:public:sysdig-monitor:(jp-tok|jp-osa|ca-tor|br-sao|au-syd|eu-gb|eu-es|us-south|eu-de|us-east):a/[0-9a-f]{32}:[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}::", var.monitoring_crn)) : true
    error_message = "Must be a valid cloud monitoring crn"
  }
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

##############################################################################
# COS bucket encryption variables
##############################################################################

variable "existing_kms_instance_guid" {
  description = "The GUID of the Key Protect or Hyper Protect instance in which the key specified in var.kms_key_crn is coming from. Required if var.skip_iam_authorization_policy is false in order to create an IAM Access Policy to allow Key Protect or Hyper Protect to access the newly created COS instance."
  type        = string
  default     = null

  validation {
    condition     = var.existing_kms_instance_guid != null ? can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.existing_kms_instance_guid)) : true
    error_message = "must be a valid cos instance id"
  }
}

##############################################################
# Context-based restriction (CBR)
##############################################################

variable "bucket_cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
    tags = optional(list(object({
      name  = string
      value = string
    })), [])
    operations = optional(list(object({
      api_types = list(object({
        api_type_id = string
      }))
    })))
  }))
  description = "(Optional, list) List of CBR rules to create for the bucket"
  default     = []
  # Validation happens in the rule module
}

variable "instance_cbr_rules" {
  type = list(object({
    description = string
    account_id  = string
    rule_contexts = list(object({
      attributes = optional(list(object({
        name  = string
        value = string
    }))) }))
    enforcement_mode = string
    tags = optional(list(object({
      name  = string
      value = string
    })), [])
    operations = optional(list(object({
      api_types = list(object({
        api_type_id = string
      }))
    })))
  }))
  description = "(Optional, list) List of CBR rules to create for the instance"
  default     = []
  # Validation happens in the rule module
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance in `existing_kms_instance_guid`. WARNING: An authorization policy must exist before an encrypted bucket can be created"
  default     = false
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
  description = "name of the custom role created access granted to cloudability service id to read from the billing reports cos bucket"
  default     = "CloudabilityStorageCustomRole"
}

variable "cloudability_enterprise_custom_role_name" {
  type        = string
  description = "name of the custom role to granting access to a cloudability service id to read the enterprise information. Only used of var.is_enterprise_account is set."
  default     = "CloudabilityListAccCustomRole"
}

variable "cos_folder" {
  type        = string
  description = "Folder in the COS bucket to store the account data"
  default     = "IBMCloud-Billing-Reports"
}

variable "skip_verification" {
  type        = bool
  description = "whether to verify the account after adding the account to cloudability. Requires cloudability_auth_header to be set."
  default     = false
}


variable "enable_cloudability_access" {
  type        = bool
  description = "Whether to grant cloudability access to read the billing reports"
  default     = true
}

variable "cloudability_host" {
  description = "IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting_started_with_the_cloudability.htm#authentication"
  type        = string
  default     = "api.cloudability.com"
}
