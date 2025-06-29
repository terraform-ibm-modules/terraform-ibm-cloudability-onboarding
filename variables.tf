
variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key corresponding to the cloud account that will be added to Cloudability. For enterprise accounts this should be the primary enterprise account"
  sensitive   = true
}

variable "cloudability_api_key" {
  type        = string
  description = "Cloudability API Key. Retrieve your Api Key from https://app.apptio.com/cloudability#/settings/preferences under the section **Cloudability API** select **Enable API** which will generate an api key. Setting this value to __NULL__ will skip adding the IBM Cloud account to Cloudability and only configure IBM Cloud so that the IBM Cloud Account can be added to Cloudability manually"
  sensitive   = true
  default     = null
}

variable "cloudability_environment_id" {
  type        = string
  description = "An ID corresponding to your FrontDoor environment. Required if `cloudability_auth_type` = `frontdoor`"
  default     = null
}

variable "frontdoor_public_key" {
  type        = string
  description = "The public key that is used along with the `frontdoor_secret_key` to authenticate requests to Cloudability. Only required if `cloudability_auth_type` is `frontdoor`. See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials."
  default     = null
}

variable "cloudability_auth_type" {
  type        = string
  description = "Select Cloudability authentication mode. Options are:\n\n* `none`: no connection to Cloudability\n* `manual`: manually enter in the credentials in the Cloudability UI\n* `api_key`: use Cloudability API Keys\n* `frontdoor`: Frontdoor Access Administration"
  default     = "api_key"
  nullable    = false
  validation {
    condition     = var.cloudability_auth_type != null ? contains(["api_key", "frontdoor", "manual", "none"], var.cloudability_auth_type) : true
    error_message = "Must have one of the value following values: `none`, `manual`, `api_key`, or `frontdoor`"
  }
}

variable "frontdoor_secret_key" {
  type        = string
  description = "The secret key that is used along with the `frontdoor_public_key` to authenticate requests to Cloudability. Only required if `cloudability_auth_type` is `frontdoor`.  See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials."
  sensitive   = true
  default     = null
}

variable "is_enterprise_account" {
  type        = bool
  description = "Whether the account corresponding to the `ibmcloud_api_key` is an enterprise account and, if so, is the primary account within the enterprise"
  default     = false
}

variable "enterprise_id" {
  type        = string
  description = "The ID of the enterprise. If `__NULL__` then it is automatically retrieved if `is_enterprise_account` is `true`. Providing this value reduces the access policies that are required to run the DA."
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
  description = "Whether access to the Object Storage bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup)."
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
  description = "Whether `resource_group_name` input represents the name of an existing resource group or a new resource group should be created"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or existing resource group where resources are created"
  default     = "cloudability-enablement"

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

variable "use_existing_key_ring" {
  type        = string
  description = "Whether the `key_ring_name` corresponds to an existing key ring or a new key ring for storing the encryption key"
  default     = false
}

variable "key_name" {
  type        = string
  description = "Name of the Object Storage bucket encryption key"
  default     = null
  validation {
    condition     = var.key_name != null ? can(regex("^[a-zA-Z0-9-_]{2,90}$", var.key_name)) : true
    error_message = "Possible values: 2 ≤ length ≤ 90, Value must match regular expression ^[a-zA-Z0-9-]{2,90}$"
  }

}


##############################################################################
# COS instance variables
##############################################################################

variable "cos_instance_name" {
  description = "The name to give the Cloud Object Storage instance that will be provisioned by this module. Only required if 'create_cos_instance' is true."
  type        = string
  default     = "billing-report-exports"
  validation {
    condition     = can(regex("^([^[:ascii:]]|[a-zA-Z0-9-._: ]){0,179}$", var.cos_instance_name))
    error_message = "must be a valid resource instance name"
  }
}

variable "cos_plan" {
  description = "Plan to be used for creating Cloud Object Storage instance. Only used if 'create_cos_instance' is true."
  type        = string
  default     = "cos-one-rate-plan"
  validation {
    condition     = contains(["standard", "lite", "cos-one-rate-plan"], var.cos_plan)
    error_message = "The specified cos_plan is not a valid selection!"
  }
}

variable "existing_cos_instance_id" {
  description = "The ID of an existing Cloud Object Storage instance. Required if 'var.create_cos_instance' is false."
  type        = string
  default     = null

  validation {
    condition     = var.existing_cos_instance_id != null ? can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.existing_cos_instance_id)) : true
    error_message = "must be a valid cos instance id"
  }
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
  default     = "billing-reports"
  validation {
    condition     = can(regex("^[a-z][0-9a-z\\.\\-]{1,57}$", var.bucket_name))
    error_message = "must be a valid bucket name between 3 and 58 characters long and composed of lowercase letters, numbers, dots (periods) or dashes (hyphens). Bucket names must begin and end with a lowercase letter or number. see https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-compatibility-api-bucket-operations#compatibility-api-new-bucket"
  }
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add random generated suffix (4 characters long) to the newly provisioned Object Storage bucket name (Optional)."
  default     = true
}

variable "bucket_storage_class" {
  type        = string
  description = "The storage class of the newly provisioned Object Storage bucket. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`."
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

variable "overwrite_existing_reports" {
  description = "A new version of report is created or the existing report version is overwritten with every update."
  type        = bool
  default     = true
}

variable "object_versioning_enabled" {
  description = "Enable [object versioning](/docs/cloud-object-storage?topic=cloud-object-storage-versioning) to keep multiple versions of an object in a bucket."
  type        = bool
  default     = false
}

variable "archive_days" {
  description = "Specifies the number of days when the archive rule action takes effect. A value of `null` disables archiving. A value of `0` immediately archives uploaded objects to the bucket."
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
  default     = 3
}

variable "activity_tracker_read_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_write_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker."
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
  validation {
    condition     = var.monitoring_crn != null ? can(regex("crn:v1:(bluemix|ibmcloud):public:sysdig-monitor:(jp-tok|jp-osa|ca-tor|br-sao|au-syd|eu-gb|eu-es|us-south|eu-de|us-east):a/[0-9a-f]{32}:[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}::", var.monitoring_crn)) : true
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
# Object Storage bucket encryption variables
##############################################################################

variable "existing_kms_instance_crn" {
  description = "The CRN of an existing Key Protect or Hyper Protect Crypto Services instance. Required if 'create_key_protect_instance' is false."
  type        = string
  default     = null

  validation {
    condition     = var.existing_kms_instance_crn != null ? can(regex("crn:v1:(bluemix|ibmcloud):public:(kms|hs-crypto):(.+):a/[0-9a-f]{32}:[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}::", var.existing_kms_instance_crn)) : true
    error_message = "Must be a valid key managed service crn"
  }
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

variable "kms_endpoint_type" {
  type        = string
  description = "The type of endpoint to be used for management of key protect."
  default     = "public"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "The endpoint_type value must be 'public' or 'private'."
  }
}

variable "kms_rotation_enabled" {
  type        = bool
  description = "If set to true, Key Protect enables a rotation policy on the Key Protect instance. Only used if 'create_key_protect_instance' is true."
  default     = true
}

variable "kms_rotation_interval_month" {
  type        = number
  description = "Specifies the number of months for the encryption key to be rotated.. Must be between 1 and 12 inclusive."
  default     = 1
  validation {
    condition     = var.kms_rotation_interval_month >= 1 && var.kms_rotation_interval_month <= 12
    error_message = "The key rotation time interval must be greater than 0 and less than 13"
  }
}

##############################################################
# Context-based restriction (CBR)
##############################################################

variable "cbr_enforcement_mode" {
  type        = string
  description = "The rule enforcement mode: * enabled - The restrictions are enforced and reported. This is the default. * disabled - The restrictions are disabled. Nothing is enforced or reported. * report - The restrictions are evaluated and reported, but not enforced."
  default     = "enabled"
  validation {
    condition     = contains(["enabled", "disabled", "report"], var.cbr_enforcement_mode)
    error_message = "Invalid cbr_enforcement_mode: use one of \"enabled\", \"disabled\", or \"report\". See CBR Rule Enforcement docs for more details: https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis&interface=ui#rule-enforcement"
  }
}
variable "cbr_billing_zone_name" {
  type        = string
  description = "Name of the CBR zone which represents IBM Cloud billing. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis)"
  default     = "billing-reports-bucket-writer"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_billing_zone_name))
    error_message = "Invalid `cbr_billing_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "cbr_cloudability_zone_name" {
  type        = string
  description = "Name of the CBR zone which represents IBM Cloudability. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis)"
  default     = "cldy-reports-bucket-reader"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_cloudability_zone_name))
    error_message = "Invalid `cbr_cloudability_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "cbr_cos_zone_name" {
  type        = string
  description = "Name of the CBR zone which represents Cloud Object Storage service. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis)"
  default     = "cldy-reports-object-storage"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_cos_zone_name))
    error_message = "Invalid `cbr_cloudability_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "cbr_schematics_zone_name" {
  type        = string
  description = "Name of the CBR zone which represents Schematics. The schematics zone allows Projects to access and manage the Object Storage bucket."
  default     = "schematics-reports-bucket-management"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_schematics_zone_name))
    error_message = "Invalid `cbr_schematics_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "cbr_additional_zone_name" {
  type        = string
  description = "Name of the CBR zone that corresponds to the ip address range set in `additional_allowed_cbr_bucket_ip_addresses`."
  default     = "additional-billing-reports-bucket-access"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_additional_zone_name))
    error_message = "Invalid `cbr_additional_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "additional_allowed_cbr_bucket_ip_addresses" {
  type        = list(string)
  description = "A list of CBR zone IP addresses, which are permitted to access the bucket.  This zone typically represents the IP addresses for your company or workstation to allow access to view the contents of the bucket."
  default     = []
}

variable "existing_allowed_cbr_bucket_zone_id" {
  type        = string
  description = "An extra CBR zone ID which is permitted to access the bucket.  This zone typically represents the ip addresses for your company or workstation to allow access to view the contents of the bucket. It can be used as an alternative to `additional_allowed_cbr_bucket_ip_addresses` in the case that a zone exists."
  default     = null
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Set to true to skip the creation of an IAM authorization policy that permits the Object Storage instance created to read the encryption key from the KMS instance in `existing_kms_instance_crn`. WARNING: An authorization policy must exist before an encrypted bucket can be created"
  default     = false
}

variable "use_existing_iam_custom_role" {
  type        = bool
  description = "Whether the iam_custom_roles should be created or if they already exist and they should be linked with a datasource"
  default     = false
}

variable "skip_cloudability_billing_policy" {
  type        = bool
  description = "Whether policy which grants cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run."
  default     = false
}

variable "cloudability_iam_custom_role_name" {
  type        = string
  description = "Name of the custom role which grants access to the Cloudability service id to read the billing reports from the object storage bucket"
  default     = "CloudabilityStorageCustomRole"
}

variable "cloudability_iam_enterprise_custom_role_name" {
  type        = string
  description = "Name of the custom role which grants access to the Cloudability service ID to read the enterprise information. Only used if `is_enterprise_account` is `true`."
  default     = "CloudabilityListAccCustomRole"
}

variable "cos_folder" {
  type        = string
  description = "Folder in the Object Storage bucket to store the account data"
  default     = "IBMCloud-Billing-Reports"
}

variable "skip_verification" {
  type        = bool
  description = "Whether to verify that the IBM Cloud account is successfully integrated with Cloudability. This step is not strictly necessary for adding the account to Cloudability. Only applicable when `cloudability_auth_type` is `api_key`."
  default     = false
}


variable "enable_cloudability_access" {
  type        = bool
  description = "Whether to grant cloudability access to read the billing reports"
  default     = true
}

variable "cloudability_host" {
  description = "IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting%20started%20with%20the%20cloudability.htm"
  type        = string
  default     = "api.cloudability.com"
}
