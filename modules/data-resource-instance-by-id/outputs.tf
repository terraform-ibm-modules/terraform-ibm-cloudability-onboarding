########################################################################################################################
# Outputs
########################################################################################################################

output "name" {
  description = "name of the resource instance"
  value       = local.resource_instance.name
}

output "crn" {
  description = "crn of the resource instance"
  value       = local.resource_instance.crn
}

output "region_id" {
  description = "region_id of the resource instance"
  value       = local.resource_instance.region_id
}

output "resource_group_id" {
  description = "region_id of the resource instance"
  value       = local.resource_instance.resource_group_id
}

output "resource_plan_id" {
  description = "resource_plan_id of the resource instance"
  value       = local.resource_instance.resource_plan_id
}
