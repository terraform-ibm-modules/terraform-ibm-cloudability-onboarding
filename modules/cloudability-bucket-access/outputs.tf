output "custom_role_display_name" {
  description = "Display name of the cos custom role"
  value       = local.custom_role
}

output "service_policy" {
  description = "The policy granted to the ServiceId"
  value       = local.policy
}
