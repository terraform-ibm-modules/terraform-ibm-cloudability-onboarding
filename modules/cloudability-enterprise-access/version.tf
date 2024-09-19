# Specify the required Terraform version for this configuration.
terraform {
  required_version = ">=1.3.0"

  # Define the required providers and their sources.
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.59.0, < 2.0.0"
    }
  }
}
