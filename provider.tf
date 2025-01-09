########################################################################################################################
# Provider config
########################################################################################################################

locals {
  # validations of the variables corresponding
  auth_credentials = var.cloudability_environment_id != null && var.frontdoor_public_key != null && var.frontdoor_secret_key != null ? "frontdoor" : (var.cloudability_api_key != null ? "cloudability" : (contains(["none", "manual"], var.cloudability_auth_type) ? "none" : null))

  # tflint-ignore: terraform_unused_declarations
  validate_front_door_credentials = var.cloudability_auth_type == "frontdoor" && local.auth_credentials != "frontdoor" ? tobool("`cloudability_auth_type` == \"frontdoor\" requires that inputs `frontdoor_public_key`, `frontdoor_secret_key` and `cloudability_environment_id` all be set. Consider changing the authentication type (cloudability_auth_type) or review the credentials guide: https://cloud.ibm.com/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#acquiring-api-key") : true

  # tflint-ignore: terraform_unused_declarations
  validate_cloudability_credentials = var.cloudability_auth_type == "api_key" && local.auth_credentials != "cloudability" ? tobool("`cloudability_auth_type` == \"api_key\" requires that inputs `cloudability_api_key` be set. Consider changing the authentication type (cloudability_auth_type) or review the credentials guide: https://cloud.ibm.com/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key") : true
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
}

provider "cloudability" {
  apikey = var.cloudability_api_key
}

module "frontdoor_auth" {
  count  = local.auth_credentials == "frontdoor" ? 1 : 0
  source = "./modules/frontdoor-opentoken"
  key    = var.frontdoor_public_key
  secret = var.frontdoor_secret_key
}

locals {
  cloudability_request_headers = local.auth_credentials == "frontdoor" ? ({
    "apptio-opentoken"     = local.auth_credentials == "frontdoor" ? module.frontdoor_auth[0].token : null
    "apptio-environmentid" = var.cloudability_environment_id
    }) : (local.auth_credentials == "cloudability" ? ({
      Authorization = var.cloudability_api_key != null ? "Basic ${base64encode("${var.cloudability_api_key}:")}" : null
  }) : null)
}

provider "restapi" {
  alias                 = "cloudability"
  uri                   = "https:"
  create_returns_object = true
  write_returns_object  = true
  debug                 = true
  headers = merge({
    Content-Type = "application/json"
    Accept       = "application/json"
    },
  local.cloudability_request_headers)
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
