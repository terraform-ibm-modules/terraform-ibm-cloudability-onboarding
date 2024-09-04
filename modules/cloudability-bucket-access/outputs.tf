output "custom_role_display_name" {
  description = "Display name of the cos custom role"
  value       = ibm_iam_custom_role.cos_custom_role.display_name
}

output "service_policy" {
  description = "The policy granted to the ServiceId"
  value       = local.policy
}
