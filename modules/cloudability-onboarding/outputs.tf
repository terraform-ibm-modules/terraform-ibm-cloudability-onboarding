output "cloudability_account_verification_state" {
  value       = local.should_verify_account ? data.cloudability_account_verification.ibm_account[0].state : null
  description = "Current state of the cloudability account verification if var.skip_verification is enabled"
}
