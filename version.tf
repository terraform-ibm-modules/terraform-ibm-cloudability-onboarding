# Specify the required Terraform version for this configuration.
terraform {
  required_version = ">=1.3.0"

  # Define the required providers and their sources.
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.69.2"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.20.0"
    }
    cloudability = {
      source  = "skyscrapr/cloudability"
      version = "0.0.36"
    }
  }
}
