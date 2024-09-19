##############################################################################
# Outputs
##############################################################################

output "resource_group_id" {
  description = "Resource Group ID"
  value       = var.resource_group_id
}

output "s3_endpoint_private" {
  description = "S3 private endpoint"
  value       = module.cos_bucket.s3_endpoint_private
}

output "s3_endpoint_public" {
  description = "S3 public endpoint"
  value       = module.cos_bucket.s3_endpoint_public
}

output "s3_endpoint_direct" {
  description = "S3 direct endpoint"
  value       = module.cos_bucket.s3_endpoint_direct
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
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].kms_guid : null
}

output "key_protect_id" {
  description = "Key Protect service instance ID when an instance is created, otherwise null"
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].key_protect_id : null
}

output "key_protect_name" {
  description = "Key Protect Name"
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].key_protect_name : null
}

output "key_protect_instance_policies" {
  description = "Instance Polices of the Key Protect instance"
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].key_protect_instance_policies : null
}

output "key_rings" {
  description = "IDs of new Key Rings created by the module"
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].key_rings : null
}

output "keys" {
  description = "IDs of new Keys created by the module"
  value       = local.key_management_enabled ? module.key_protect_all_inclusive[0].keys : null
}