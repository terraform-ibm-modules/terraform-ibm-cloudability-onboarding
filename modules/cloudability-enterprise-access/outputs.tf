output "custom_role_display_name" {
  description = "Display name of the enterprise custom role to read the list of enterprise custom accounts"
  value       = local.custom_role
}

output "enterprise_policy" {
  description = "The policy granted to the ServiceId to read the enterprise"
  value       = var.enterprise_id != null ? ibm_iam_service_policy.enterprise_policy[0] : null
}


output "billing_policy" {
  description = "The policy granted to the ServiceId for reading billing"
  value       = ibm_iam_service_policy.billing_policy
}
