data "ibm_iam_auth_token" "tokendata" {
}
data "http" "resource_instance" {
  url    = "https://resource-controller.cloud.ibm.com/v2/resource_instances/${var.guid}"
  method = "GET"
  request_headers = {
    Accept        = "application/json"
    Content-Type  = "application/json"
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }
  lifecycle {
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = "Status code invalid"
    }
  }
}

locals {
  fields = {
    guid              = true
    crn               = true
    name              = true
    region_id         = true
    resource_group_id = true
    resource_plan_id  = true
  }
  response          = jsondecode(data.http.resource_instance.response_body)
  resource_instance = { for key, value in local.response : key => value if try(local.fields[key], false) }
}
