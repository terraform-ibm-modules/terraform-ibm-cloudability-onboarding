data "ibm_iam_account_settings" "iam_account_settings" {
  count = var.billing_account_id == null ? 1 : 0
}

# module "cos_bucket_crn" {
#   # source = "git::https://github.com/terraform-ibm-modules/terraform-ibmcloud-crn-module.git?ref=1.0.0"
#   source = "../terraform-ibmcloud-crn-module"
#   crn    = var.cos_bucket_crn
# }

locals {
  subject_account_id  = var.billing_account_id == null ? data.ibm_iam_account_settings.iam_account_settings[0].account_id : var.billing_account_id
  resource_account_id = split("/", split(":", var.cos_bucket_crn)[6])[1]
  cos_instance_id     = split(":", var.cos_bucket_crn)[7]
  bucket_name         = split(":", var.cos_bucket_crn)[9]
  resource_attributes = [
    {
      name  = "accountId"
      value = local.resource_account_id
    },
    {
      name  = "serviceName"
      value = "cloud-object-storage"
    },
    {
      name  = "serviceInstance"
      value = local.cos_instance_id
    },
    {
      name  = "resourceType"
      value = "bucket"
    },
    {
      name  = "resource"
      value = local.bucket_name
    }
  ]
  resource_attributes_optionally_include_resource_group = var.resource_group_id == null ? local.resource_attributes : concat(local.resource_attributes, [{
    name  = "resourceGroupId"
    value = var.resource_group_id
  }])
}

# Allow the code engine project to receive triggers from COS
resource "ibm_iam_authorization_policy" "billing_to_cos_authorization" {
  count = var.skip_authorization_policy ? 0 : 1
  subject_attributes {
    name  = "accountId"
    value = local.subject_account_id
  }

  subject_attributes {
    name  = "serviceName"
    value = "billing"
  }

  dynamic "resource_attributes" {
    for_each = local.resource_attributes_optionally_include_resource_group
    content {
      name  = resource_attributes.value["name"]
      value = resource_attributes.value["value"]
    }
  }

  roles = ["Object Writer", "Content Reader"]
}

# workaround for https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4478
resource "time_sleep" "wait_for_authorization_policy" {
  count      = var.skip_authorization_policy ? 0 : 1
  depends_on = [ibm_iam_authorization_policy.billing_to_cos_authorization[0]]

  create_duration = "30s"
}

resource "null_resource" "billing_report_replacement_trigger" {
  triggers = {
    cos_bucket         = local.bucket_name
    cos_location       = var.cos_bucket_location
    cos_reports_folder = var.cos_folder
  }
}

resource "ibm_billing_report_snapshot" "billing_report_snapshot_instance" {
  cos_bucket         = local.bucket_name
  cos_location       = var.cos_bucket_location
  interval           = var.interval
  cos_reports_folder = var.cos_folder
  report_types       = var.report_types
  versioning         = var.versioning
  depends_on         = [time_sleep.wait_for_authorization_policy[0], null_resource.billing_report_replacement_trigger]
  lifecycle {
    ignore_changes = [
      # Ignore changes to report_types, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      report_types,
    ]
    # If there is a change in the billing report cos_bucket, cos_reports_folder, or cos_location then we need to delete and recreate the billing snapshots
    # because updating this configuration will not cause the billing reports to be sent immediately which causes the validation in cloudability to fail
    # since no files get written until the next day
    replace_triggered_by = [
      null_resource.billing_report_replacement_trigger
    ]
  }
}


locals {
  # billing_report_snapshot_instance = var.skip_authorization_policy ? ibm_billing_report_snapshot.billing_report_snapshot_instance[0] : ibm_billing_report_snapshot.billing_report_snapshot_instance_skipped_auth_policy[0]
  billing_report_snapshot_instance = ibm_billing_report_snapshot.billing_report_snapshot_instance
}
