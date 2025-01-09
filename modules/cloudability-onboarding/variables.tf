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
  description = "CRN of the Object Storage bucket"
}

variable "cos_bucket_location" {
  type        = string
  description = "Location of the Object Storage bucket."
}

variable "cos_bucket_prefix" {
  type        = string
  description = "name of the manifest file in the cost report"
  default     = "IBMCloud-Billing-Reports"
}

variable "skip_verification" {
  type        = bool
  description = "whether to verify the account after adding the account to cloudability."
  default     = true
}

variable "cos_instance_name" {
  description = "The name to give the Cloud Object Storage instance that will be provisioned by this module. If not specified then the instance name is retrieved from the instance crn from the bucket"
  type        = string
  default     = null
}

variable "cloudability_host" {
  description = "IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting%20started%20with%20the%20cloudability.htm"
  type        = string
  default     = "api.cloudability.com"
}
