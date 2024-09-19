########################################################################################################################
# Outputs
########################################################################################################################

output "id" {
  description = "The unique identifier of the billing_report_snapshot."
  value       = local.billing_report_snapshot_instance.id
}

output "export_state" {
  description = "The current state of the billing exports. Either enabled or disabled."
  value       = local.billing_report_snapshot_instance.state
}

output "export_content_type" {
  description = "The content type of the billing exports. default is text/csv"
  value       = local.billing_report_snapshot_instance.content_type
}

output "export_cos_write_location" {
  description = "COS url to the write location"
  value       = "${local.billing_report_snapshot_instance.cos_endpoint}/${local.billing_report_snapshot_instance.cos_bucket}/${local.billing_report_snapshot_instance.cos_reports_folder}"
}
output "export_compression" {
  description = "type of compression for the exports"
  value       = local.billing_report_snapshot_instance.compression
}

output "export_account_type" {
  description = "Date that the exports were last updated"
  value       = local.billing_report_snapshot_instance.account_type
}
