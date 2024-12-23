##############################################################################
# Outputs
##############################################################################

output "resource_group_id" {
  description = "ID of the resource group where all resources are deployed into"
  value       = module.resource_group.resource_group_id
}
output "s3_endpoint_public" {
  description = "Public endpoint to the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.s3_endpoint_public
}

output "s3_endpoint_private" {
  description = "Private endpoint to the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.s3_endpoint_private
}

output "s3_endpoint_direct" {
  description = "Direct endpoint to the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.s3_endpoint_direct
}

output "bucket_id" {
  description = "ID of the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.bucket_id
}

output "bucket_crn" {
  description = "CRN of the Object Storage bucket where billing reports are written to"
  value       = local.cos_bucket_crn
}

output "bucket_region" {
  description = "CRN of the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.bucket_region
}

output "bucket_name" {
  description = "Name of the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.bucket_name
}

output "bucket_storage_class" {
  description = "Storage class of the Object Storage bucket where billing reports are written to"
  value       = module.cos_bucket.bucket_storage_class
}

output "cos_instance_id" {
  description = "The ID of the Cloud Object Storage instance where the billing reports bucket is created"
  value       = module.cos_bucket.cos_instance_id
}

output "cos_instance_guid" {
  description = "The GUID of the Cloud Object Storage instance where the billing reports bucket is created"
  value       = module.cos_bucket.cos_instance_guid
}

output "cos_instance_name" {
  description = "Name of the Cloud Object Storage instance"
  value       = local.cos_instance_name
}

output "cos_bucket_folder" {
  description = "Folder in the Object Storage bucket to store the account data"
  value       = var.cos_folder
}

output "cos_cbr_rule_ids" {
  description = "List of all rule ids"
  value       = module.cos_bucket.cbr_rule_ids
}
output "bucket_cbr_rules" {
  description = "Object Storage bucket rules"
  value       = module.cos_bucket.bucket_cbr_rules
}

output "kms_key_crn" {
  description = "The CRN of the KMS key used to encrypt the object storage bucket"
  value       = module.cos_bucket.kms_key_crn
}

output "key_protect_guid" {
  description = "ID of the Key Protect instance which contains the encryption key for the object storage bucket"
  value       = module.cos_bucket.key_protect_guid
}

output "kms_crn" {
  description = "CRN of the KMS instance when an instance"
  value       = module.cos_bucket.kms_crn
}

output "key_protect_name" {
  description = "Name of the Key Protect instance"
  value       = module.cos_bucket.key_protect_name
}

output "key_protect_instance_policies" {
  description = "Instance Polices of the Key Protect instance"
  value       = module.cos_bucket.key_protect_instance_policies
}

output "key_rings" {
  description = "IDs of new Key Rings created by the module"
  value       = module.cos_bucket.key_rings
}

output "keys" {
  description = "IDs of new Keys created by the module"
  value       = module.cos_bucket.keys
}
output "enterprise_account_id" {
  value       = local.enterprise_account_id
  description = "ID of the IBM Cloud account or, in the case of an enterprise, the ID of the primary account in the enterprise"
}

output "enterprise_id" {
  value       = local.enterprise_id
  description = "id of the enterprise if `is_enterprise_account` is enabled"
}

output "enterprise_cloudability_custom_role_display_name" {
  value       = !var.enable_cloudability_access ? module.cloudability_enterprise_access[0].custom_role_display_name : null
  description = "Display name of the custom role that grants cloudability access to read the enterprise accounts"
}

output "bucket_account_cloudability_custom_role_display_name" {
  value       = var.cloudability_auth_type != "none" ? module.cloudability_bucket_access[0].custom_role_display_name : null
  description = "Display name of the custom role that grants cloudability access to read the billing reports from the Object Storage bucket"
}
