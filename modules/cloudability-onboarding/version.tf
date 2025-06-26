# Specify the required Terraform version for this configuration.
terraform {
  required_version = ">=1.9.0"

  # Define the required providers and their sources.
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.59.0, <2.0.0"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = ">= 2.0.0, <3.0.0"
    }
    cloudability = {
      source  = "skyscrapr/cloudability"
      version = ">= 0.0.35, <1.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2, <4.0.0"
    }
  }
}
