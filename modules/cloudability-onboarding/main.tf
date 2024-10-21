
locals {
  cos_instance_id = split(":", var.cos_bucket_crn)[7]
  bucket_name     = split(":", var.cos_bucket_crn)[9]
}

module "cos_instance" {
  count  = var.cos_instance_name == null ? 1 : 0
  source = "../data-resource-instance-by-id"
  guid   = local.cos_instance_id
}

locals {
  cos_instance_name = var.cos_instance_name == null ? module.cos_instance.name : var.cos_instance_name
}

data "ibm_iam_account_settings" "account" {
}
locals {
  cloudability_host     = "//${var.cloudability_host}"
  account_id            = data.ibm_iam_account_settings.account.account_id
  should_verify_account = !var.skip_verification
  cloudability_ibm_account_body = jsonencode({
    vendorAccountId = local.account_id
    enterpriseId    = var.enterprise_id
    region          = var.cos_bucket_location
    ibmCostReportSpec = {
      costReportName      = var.cost_report_name
      costPrefix          = var.cos_bucket_prefix
      bucketRegion        = var.cos_bucket_location
      bucketName          = local.bucket_name
      storageInstanceName = local.cos_instance_name
    }
    type = "ibm_role"
  })
}

resource "restapi_object" "cloudability_ibm_account" {
  path         = "${local.cloudability_host}/v3/vendors/ibm/accounts"
  data         = local.cloudability_ibm_account_body
  query_string = "include=permissions&viewId=0"
  id_attribute = "result/id"
  lifecycle {
    postcondition {
      condition     = self.id == local.account_id
      error_message = "Failed to add account to cloudability."
    }
  }

}


# Wait for all add-ons to be in normal state
resource "null_resource" "wait_for_billing_exports" {
  count = local.should_verify_account ? 1 : 0
  triggers = {
    bucket_name           = local.bucket_name
    cos_bucket_prefix     = var.cos_bucket_prefix
    region                = var.cos_bucket_location
    should_verify_account = local.should_verify_account
  }
  provisioner "local-exec" {
    command     = "${path.module}/scripts/wait_for_billing_exports.sh"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      ibmcloud_api_key  = var.ibmcloud_api_key
      cos_bucket_name   = local.bucket_name
      cos_bucket_prefix = var.cos_bucket_prefix
      cos_region        = var.cos_bucket_location
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo Nothing to destroy"
  }
}

data "cloudability_account_verification" "ibm_account" {
  count             = local.should_verify_account ? 1 : 0
  vendor_account_id = local.account_id
  vendor_key        = "ibm"
  depends_on        = [null_resource.wait_for_billing_exports[0], restapi_object.cloudability_ibm_account]
  lifecycle {
    postcondition {
      condition     = self.state == "verified"
      error_message = self.state == "unverified" ? "IBM Account `${local.account_id}` is unverified." : "Error in verification of IBM Account `${local.account_id}`: ${self.message}."
    }
  }
}
