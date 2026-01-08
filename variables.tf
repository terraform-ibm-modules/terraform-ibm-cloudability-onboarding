
variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key corresponding to the cloud account to be added to Cloudability. For enterprise accounts, create the API key in the primary enterprise account to add all child accounts within your enterprise. See [configuring IBM Cloud IAM permissions](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#cloudability-iam-prereqs)"
  sensitive   = true
}

variable "cloudability_api_key" {
  type        = string
  description = "(For Access Administration only) Cloudability API Key used to authenticate with Cloudability to add the IBM Cloud account to the Cloudability environment. See [how to retrieve your Cloudability API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#api-key) or visit the [cloudability preferences page](https://app.apptio.com/cloudability#/settings/preferences). \nRequired if `Authentication Mode` is set to `Cloudability Authentication`."
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
  description = "(For Access Administration mode only) Public key that is used along with the `frontdoor_secret_key` to authenticate requests to Cloudability. See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials. Required if `Authentication Mode` is `Access Administration`"
  default     = null
}

variable "cloudability_auth_type" {
  type        = string
  description = "Select Cloudability authentication mode. Options are:\n\n* `none`: no connection to Cloudability\n* `manual`: manually enter the credentials in the Cloudability UI\n* `api_key`: use Cloudability API Keys\n* `frontdoor`: Frontdoor Access Administration"
  default     = "api_key"
  nullable    = false
  validation {
    condition     = var.cloudability_auth_type != null ? contains(["api_key", "frontdoor", "manual", "none"], var.cloudability_auth_type) : true
    error_message = "Must have one of the following values: `none`, `manual`, `api_key`, or `frontdoor`"
  }
}

variable "frontdoor_secret_key" {
  type        = string
  description = "(For Access Administration mode only) Secret key that is used along with the `frontdoor_public_key` to authenticate requests to Cloudability. See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials. Required if `Authentication Mode` is `Access Administration`."
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
  description = "Whether the value of the `resource_group_name` input is for a new (true) or an existing (false) resource group"
  default     = false
}

variable "resource_group_name" {
  type        = string
  description = "The name of a new or existing resource group (depends on `use_existing_resource_group`) where resources are created."
  default     = "cloudability-enablement"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_ ]+$", var.resource_group_name)) && length(var.resource_group_name) < 40
    error_message = "Must be a valid resource group name that matches ^[a-zA-Z0-9-_ ]+$ and be less than 40 characters"
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "List of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "List of access tags to be added to the created resources"
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
  description = "Region where resources are created. Only us-south, eu-de, and jp-tok have [Key Protect failover support](https://cloud.ibm.com/docs/key-protect?topic=key-protect-ha-dr#availability)"
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
  description = "Name of the Key Protect instance that stores the Object Storage encryption key. Not needed if `existing_kms_instance_crn` is used."
  default     = "cloudability-bucket-encryption"
  validation {
    condition     = can(regex("^([^[:ascii:]]|[a-zA-Z0-9-._: ])+$", var.key_protect_instance_name)) && length(var.key_protect_instance_name) < 180
    error_message = "must be a valid resource instance name"
  }
}

variable "key_ring_name" {
  type        = string
  description = "Name of the Key Protect key ring to store the Object Storage encryption key."
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
  description = "Name of the Key Protect key for encryption of the Object Storage bucket. If `__NULL__` then the name of the Object Storage bucket is used instead."
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
  description = "The name of the newly created Cloud Object Storage instance that contains the billing reports bucket. Only used if `existing_cos_instance_id` is not defined."
  type        = string
  default     = "billing-report-exports"
  validation {
    condition     = can(regex("^([^[:ascii:]]|[a-zA-Z0-9-._: ]){0,179}$", var.cos_instance_name))
    error_message = "must be a valid resource instance name"
  }
}

variable "cos_plan" {
  description = "Plan to be used for creating Cloud Object Storage instance. Only used if `existing_cos_instance_id` is not defined."
  type        = string
  default     = "cos-one-rate-plan"
  validation {
    condition     = contains(["standard", "lite", "cos-one-rate-plan"], var.cos_plan)
    error_message = "The specified cos_plan is not a valid selection!"
  }
}

variable "existing_cos_instance_id" {
  description = "The ID of an existing Object Storage instance. If `__NULL__` then a new instance is created."
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
  description = "Name of the Cloud Object Storage (COS) bucket where billing reports are stored"
  default     = "billing-reports"
  validation {
    condition     = can(regex("^[a-z][0-9a-z\\.\\-]{1,57}$", var.bucket_name))
    error_message = "must be a valid bucket name between 3 and 58 characters long and composed of lowercase letters, numbers, dots (periods) or dashes (hyphens). Bucket names must begin and end with a lowercase letter or number. see https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-compatibility-api-bucket-operations#compatibility-api-new-bucket"
  }
}

variable "add_bucket_name_suffix" {
  type        = bool
  description = "Add a randomly generated suffix (4 characters long) to the `bucket_name` to ensure global uniqueness."
  default     = true
}

variable "bucket_storage_class" {
  type        = string
  description = "The storage class of the newly provisioned Object Storage bucket of a `standard` or `lite` plan instance. Not required for one rate instances."
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
  description = "Whether each update overwrites the existing report version, or a new version of the report is created, leaving the existing report"
  type        = bool
  default     = true
}

variable "object_versioning_enabled" {
  description = "Enable object versioning to keep multiple versions of an object in the Object Storage bucket"
  type        = bool
  default     = false
}

variable "archive_days" {
  description = "Specifies the number of days when the archive rule action takes effect. A value of `__NULL__` disables archiving. A value of `0` immediately archives uploaded objects to the bucket."
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
  description = "Specifies the number of days when the expire rule action takes effect. [Learn more](/docs/cloud-object-storage?topic=cloud-object-storage-expiry)"
  type        = number
  default     = 3
}

variable "activity_tracker_read_data_events" {
  type        = bool
  description = "If set to `true`, all Object Storage bucket read events (downloads) are sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_write_data_events" {
  type        = bool
  description = "If set to true, all Object Storage bucket write events (uploads) are sent to Activity Tracker."
  default     = true
}

variable "activity_tracker_management_events" {
  type        = bool
  description = "If set to true, all Object Storage management events are sent to Activity Tracker."
  default     = true
}

variable "monitoring_crn" {
  type        = string
  description = "The CRN of an IBM Cloud Monitoring instance to send Object Storage bucket metrics to. If no value is passed, metrics are configured in Metrics Router service configuration."
  default     = null
  validation {
    condition     = var.monitoring_crn != null ? can(regex("crn:v1:(bluemix|ibmcloud):public:sysdig-monitor:(jp-tok|jp-osa|ca-tor|br-sao|au-syd|eu-gb|eu-es|us-south|eu-de|us-east):a/[0-9a-f]{32}:[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}::", var.monitoring_crn)) : true
    error_message = "Must be a valid cloud monitoring crn"
  }
}

variable "request_metrics_enabled" {
  type        = bool
  description = "If set to `true`, all Object Storage bucket request metrics are sent to the monitoring service."
  default     = true
}

variable "usage_metrics_enabled" {
  type        = bool
  description = "If set to `true`, all Object Storage bucket usage metrics are sent to the monitoring service."
  default     = true
}

##############################################################################
# Object Storage bucket encryption variables
##############################################################################

variable "existing_kms_instance_crn" {
  description = "The CRN of an existing Key Protect or Hyper Protect Crypto Services instance to be used to create the object storage encryption key."
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
  description = "The type of endpoint to be used for management of Key Protect."
  default     = "public"
  validation {
    condition     = can(regex("public|private", var.kms_endpoint_type))
    error_message = "The endpoint_type value must be 'public' or 'private'."
  }
}

variable "kms_rotation_enabled" {
  type        = bool
  description = "If set to true, Key Protect enables a rotation policy on the Key Protect instance."
  default     = true
}

variable "kms_rotation_interval_month" {
  type        = number
  description = "Specifies the number of months for the encryption key to be rotated. Must be between 1 and 12 inclusive."
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
  description = "The rule enforcement mode: \n* enabled - The restrictions are enforced and reported.\n* disabled - The restrictions are disabled. Nothing is enforced or reported.\n* report - The restrictions are evaluated and reported, but not enforced."
  default     = "enabled"
  validation {
    condition     = contains(["enabled", "disabled", "report"], var.cbr_enforcement_mode)
    error_message = "Invalid cbr_enforcement_mode: use one of \"enabled\", \"disabled\", or \"report\". See CBR Rule Enforcement docs for more details: https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis&interface=ui#rule-enforcement"
  }
}
variable "cbr_billing_zone_name" {
  type        = string
  description = "Name of the CBR zone that represents IBM Cloud billing"
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
  description = "An extra CBR zone ID that is permitted to access the bucket. This zone typically represents the IP addresses for your company or workstation to allow access to view the contents of the bucket. It can be used as an alternative to `additional_allowed_cbr_bucket_ip_addresses` when a zone already exists."
  default     = "additional-billing-reports-bucket-access"
  validation {
    condition     = can(regex("^[a-zA-Z0-9 -_]{1,128}$", var.cbr_additional_zone_name))
    error_message = "Invalid `cbr_additional_zone_name`: value must meet the following regular expression /^[a-zA-Z0-9 -_]+$/ and have length > 1 and < 128"
  }
}

variable "additional_allowed_cbr_bucket_ip_addresses" {
  type        = list(string)
  description = "A list of CBR zone addresses or an IP address (e.g., 169.23.56.234) or range (169.23.22.0-169.23.22.255) that are permitted to access the bucket. This zone typically represents the IP addresses for your company or workstation to allow access to view the contents of the bucket."
  default     = []
}

variable "existing_allowed_cbr_bucket_zone_id" {
  type        = string
  description = "A list of CBR zone addresses that are permitted to access the bucket. This zone typically represents the IP addresses for your company or workstation to allow access to view the contents of the bucket."
  default     = null
}

variable "skip_iam_authorization_policy" {
  type        = bool
  description = "Whether to skip the creation of an IAM authorization policy that permits the Object Storage instance to read the encryption key from the Key Protect instance.\n**WARNING**: An authorization policy must exist before an encrypted bucket can be created."
  default     = false
}

variable "use_existing_iam_custom_role" {
  type        = bool
  description = "Whether the iam_custom_roles should be created or if they already exist and they should be linked with a datasource"
  default     = false
}

variable "skip_cloudability_billing_policy" {
  type        = bool
  description = "Whether to skip creating the policy that grants Cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run."
  default     = false
}

variable "cloudability_iam_custom_role_name" {
  type        = string
  description = "Name of the custom role that is used to grant the Cloudability service ID read access to the billing reports within the Object Storage bucket"
  default     = "CloudabilityStorageCustomRole"
}

variable "cloudability_iam_enterprise_custom_role_name" {
  type        = string
  description = "Name of the custom role to grant access to a Cloudability service ID to read the enterprise information. Only used if `is_enterprise_account` is set to `true`."
  default     = "CloudabilityListAccCustomRole"
}

variable "cos_folder" {
  type        = string
  description = "Directory for your account's billing report objects in the Object Storage bucket"
  default     = "IBMCloud-Billing-Reports"
}

variable "skip_verification" {
  type        = bool
  description = "Whether to verify that the IBM Cloud account is successfully integrated with Cloudability. This step is not strictly necessary for adding the account to Cloudability. Only applicable when `cloudability_auth_type` is `api_key`."
  default     = false
}


variable "enable_cloudability_access" {
  type        = bool
  description = "Whether to grant Cloudability access to read the billing reports"
  default     = true
}

variable "cloudability_host" {
  description = "IBM Cloudability hostname which depends on the region where Cloudability is created. See [Cloudability API documentation]https://www.ibm.com/docs/en/cloudability-commercial/cloudability-premium/saas?topic=api-getting-started-cloudability-v3)"
  type        = string
  default     = "api.cloudability.com"
}
