##############################################################################
# Outputs
##############################################################################

output "resource_group_id" {
  description = "Resource Group ID"
  value       = module.resource_group.resource_group_id
}
output "s3_endpoint_public" {
  description = "S3 public endpoint"
  value       = module.cos_bucket.s3_endpoint_public
}

output "bucket_id" {
  description = "Bucket id"
  value       = module.cos_bucket.bucket_id
}

output "bucket_crn" {
  description = "Bucket CRN"
  value       = module.cos_bucket.bucket_crn
}

output "bucket_name" {
  description = "Bucket name"
  value       = module.cos_bucket.bucket_name
}

output "bucket_storage_class" {
  description = "Bucket Storage Class"
  value       = module.cos_bucket.bucket_storage_class
}

output "kms_key_crn" {
  description = "The CRN of the KMS key used to encrypt the COS bucket"
  value       = module.cos_bucket.kms_key_crn
}

output "cos_instance_id" {
  description = "The ID of the Cloud Object Storage Instance where the buckets are created"
  value       = module.cos_bucket.cos_instance_id
}

output "cos_instance_guid" {
  description = "The GUID of the Cloud Object Storage Instance where the buckets are created"
  value       = module.cos_bucket.cos_instance_guid
}

output "bucket_cbr_rules" {
  description = "COS bucket rules"
  value       = module.cos_bucket.bucket_cbr_rules
}

output "instance_cbr_rules" {
  description = "COS instance rules"
  value       = module.cos_bucket.instance_cbr_rules
}

output "cbr_rule_ids" {
  description = "List of all rule ids"
  value       = module.cos_bucket.cbr_rule_ids
}

output "key_protect_guid" {
  description = "Key Protect GUID"
  value       = module.cos_bucket.key_protect_guid
}

output "key_protect_id" {
  description = "Key Protect service instance ID when an instance is created, otherwise null"
  value       = module.cos_bucket.key_protect_id
}

output "key_protect_name" {
  description = "Key Protect Name"
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
  description = "primary account id of the enterprise if `is_enterprise_account` is enabled"
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
  value       = module.cloudability_bucket_access.custom_role_display_name
  description = "Display name of the custom role that grants cloudability access to read the billing reports from the cos bucket"
}
