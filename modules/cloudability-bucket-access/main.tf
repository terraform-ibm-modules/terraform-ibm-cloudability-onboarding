locals {
  # tflint-ignore: terraform_unused_declarations
  validate_bucket_crn_set_if_for_policy_granularity = var.policy_granularity != "resourceGroup" && var.bucket_crn == null ? tobool("`bucket_crn` is required if `policy_granularity` is set to \"resource\" or \"serviceInstance\"") : null
  # tflint-ignore: terraform_unused_declarations
  validate_resource_group_set_if_for_policy_granularity = var.policy_granularity == "resourceGroup" && var.resource_group_id == null ? tobool("`resource_group_id` is a required if `policy_granularity` is set to \"resourceGroup\"") : null

  resource_group_id = var.resource_group_id

  cos_instance_id = var.policy_granularity != "resourceGroup" ? split(":", var.bucket_crn)[7] : null
  bucket_name     = var.policy_granularity != "resourceGroup" ? split(":", var.bucket_crn)[9] : null
}

locals {
  apptio_service_id = "iam-ServiceId-6bf7af4e-6f07-4894-ab72-ff539dfb951a"
}

# Define a custom IAM role for Cloud Storage with specific actions.
resource "ibm_iam_custom_role" "cos_custom_role" {
  name         = var.cloudability_custom_role_name
  display_name = var.cloudability_custom_role_name
  description  = "This is a custom role to read Cloud Storage"
  service      = "cloud-object-storage"
  actions = [
    "iam.policy.read",
    "cloud-object-storage.object.head",
    "cloud-object-storage.object.get_uploads",
    "cloud-object-storage.object.get",
    "cloud-object-storage.bucket.list_bucket_crn",
    "cloud-object-storage.bucket.head",
    "cloud-object-storage.bucket.get"
  ]
}

data "ibm_iam_roles" "cos_custom_role" {
  count   = var.use_existing_iam_custom_role ? 1 : 0
  service = "cloud-object-storage"
}

locals {
  custom_role = var.use_existing_iam_custom_role ? one([for role in data.ibm_iam_roles.cos_custom_role[0].roles : role.name if role.name == var.cloudability_custom_role_name]) : ibm_iam_custom_role.cos_custom_role.display_name
}

resource "ibm_iam_service_policy" "cos_bucket_policy" {
  count  = var.policy_granularity == "resource" ? 1 : 0
  iam_id = local.apptio_service_id
  roles  = [local.custom_role]
  resource_attributes {
    name     = "resource"
    value    = local.bucket_name
    operator = "stringEquals"
  }
  resource_attributes {
    name  = "serviceName"
    value = "cloud-object-storage"
  }
}

resource "ibm_iam_service_policy" "cos_instance_policy" {
  count  = var.policy_granularity == "serviceInstance" ? 1 : 0
  iam_id = local.apptio_service_id
  roles  = [local.custom_role]
  resource_attributes {
    name     = "serviceInstance"
    value    = local.cos_instance_id
    operator = "stringEquals"
  }
  resource_attributes {
    name  = "serviceName"
    value = "cloud-object-storage"
  }
}

resource "ibm_iam_service_policy" "cos_resource_group_policy" {
  count  = var.policy_granularity == "resourceGroup" ? 1 : 0
  iam_id = local.apptio_service_id
  roles  = [local.custom_role]
  resource_attributes {
    name     = "resourceGroupId"
    value    = local.resource_group_id
    operator = "stringEquals"
  }
  resource_attributes {
    name  = "serviceName"
    value = "cloud-object-storage"
  }
}


locals {
  policy = var.policy_granularity == "resource" ? ibm_iam_service_policy.cos_bucket_policy[0] : (var.policy_granularity == "serviceInstance" ? ibm_iam_service_policy.cos_instance_policy[0] : ibm_iam_service_policy.cos_resource_group_policy[0])
}
