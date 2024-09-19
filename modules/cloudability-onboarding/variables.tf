variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "enterprise_id" {
  type        = string
  description = "Guid for the enterprise id"
  default     = ""
}

variable "cost_report_name" {
  type        = string
  description = "name of the manifest file in the cost report"
  default     = "manifest"
}

variable "cos_bucket_crn" {
  type        = string
  description = "CRN of the COS bucket"
}

variable "cos_bucket_location" {
  type        = string
  description = "Location of the cos bucket."
}

variable "cos_bucket_prefix" {
  type        = string
  description = "name of the manifest file in the cost report"
  default     = "IBMCloud-Billing-Reports"
}

variable "skip_verification" {
  type        = bool
  description = "whether to verify the account after adding the account to cloudability. Requires cloudability_auth_header to be set."
  default     = true
}

variable "cos_instance_name" {
  description = "The name to give the cloud object storage instance that will be provisioned by this module. If not specified then the instance name is retrieved from the instance crn from the bucket"
  type        = string
  default     = null
}

variable "cloudability_host" {
  description = "IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting_started_with_the_cloudability.htm#authentication"
  type        = string
  default     = "api.cloudability.com"
}
