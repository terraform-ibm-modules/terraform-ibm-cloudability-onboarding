########################################################################################################################
# Outputs
########################################################################################################################

output "token" {
  description = "The unique identifier of the billing_report_snapshot."
  value       = local.opentoken
  sensitive   = true
}

output "status_code" {
  description = "The http status code from the authentication request."
  value       = local.status_code
}
