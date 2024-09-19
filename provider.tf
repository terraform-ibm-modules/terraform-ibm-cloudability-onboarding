########################################################################################################################
# Provider config
########################################################################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}


locals {
  cloudability_auth_header = var.cloudability_api_key != null ? "Basic ${base64encode("${var.cloudability_api_key}:")}" : null
}

provider "cloudability" {
  apikey = var.cloudability_api_key
}

provider "restapi" {
  alias                 = "cloudability"
  uri                   = "https:"
  create_returns_object = true
  write_returns_object  = true
  debug                 = true
  headers = {
    Content-Type  = "application/json"
    Authorization = local.cloudability_auth_header
  }
}


data "ibm_iam_auth_token" "tokendata" {
}
provider "restapi" {
  alias                 = "ibmcloud"
  uri                   = "https:"
  create_returns_object = true
  write_returns_object  = true
  debug                 = true
  headers = {
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    Content-Type  = "application/json"
  }
}
