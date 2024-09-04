locals {
  apptio_service_id = "iam-ServiceId-6bf7af4e-6f07-4894-ab72-ff539dfb951a"
}

resource "ibm_iam_custom_role" "list_enterprise_custom_role" {
  name         = var.cloudability_custom_role_name
  display_name = var.cloudability_custom_role_name
  description  = "This is a custom role to list Accounts in Enterprise"
  service      = "enterprise"
  actions = [
    "iam.policy.read",
    "enterprise.account.retrieve",
    "enterprise.account-group.retrieve"
  ]
}

resource "ibm_iam_service_policy" "enterprise_policy" {
  count  = var.enterprise_id != null ? 1 : 0
  iam_id = local.apptio_service_id
  roles  = [ibm_iam_custom_role.list_enterprise_custom_role.display_name]
  resource_attributes {
    name  = "serviceName"
    value = "enterprise"
  }
}

resource "ibm_iam_service_policy" "billing_policy" {
  iam_id = local.apptio_service_id
  roles  = ["Viewer"]
  resources {
    service = "billing"
  }
}
