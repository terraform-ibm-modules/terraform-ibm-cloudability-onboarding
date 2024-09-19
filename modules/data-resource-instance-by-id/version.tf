terraform {
  required_version = ">= 1.3.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.59.0, < 2.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.4.1, < 4.0.0"
    }
  }
}
