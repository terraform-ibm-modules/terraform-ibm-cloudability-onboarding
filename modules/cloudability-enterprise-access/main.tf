locals {
  apptio_service_id = "iam-ServiceId-6bf7af4e-6f07-4894-ab72-ff539dfb951a"
}

resource "ibm_iam_custom_role" "list_enterprise_custom_role" {
  count        = var.enterprise_id != null && !var.use_existing_iam_custom_role ? 1 : 0
  name         = var.cloudability_iam_custom_role_name
  display_name = var.cloudability_iam_custom_role_name
  description  = "This is a custom role to list Accounts in Enterprise"
  service      = "enterprise"
  actions = [
    "iam.policy.read",
    "enterprise.account.retrieve",
    "enterprise.account-group.retrieve"
  ]
}

data "ibm_iam_roles" "list_enterprise_custom_role" {
  count   = var.enterprise_id != null && var.use_existing_iam_custom_role ? 1 : 0
  service = "enterprise"
}

locals {
  custom_role = var.enterprise_id != null ? (var.use_existing_iam_custom_role ? one([for role in data.ibm_iam_roles.list_enterprise_custom_role[0].roles : role.name if role.name == var.cloudability_iam_custom_role_name]) : ibm_iam_custom_role.list_enterprise_custom_role[0].display_name) : null
}

resource "ibm_iam_service_policy" "enterprise_policy" {
  count  = var.enterprise_id != null ? 1 : 0
  iam_id = local.apptio_service_id
  roles  = [local.custom_role]
  resource_attributes {
    name  = "serviceName"
    value = "enterprise"
  }
}

resource "ibm_iam_service_policy" "billing_policy" {
  count  = var.skip_cloudability_billing_policy ? 0 : 1
  iam_id = local.apptio_service_id
  roles  = ["Viewer"]
  resources {
    service = "billing"
  }
}
