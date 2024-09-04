
# curl -X GET https://resource-controller.cloud.ibm.com/v2/resource_instances/8d7af921-b136-4078-9666-081bd8470d94 -H "Authorization: Bearer <IAM token>" \
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
  id_attribute = "result/id"
  lifecycle {
    postcondition {
      condition     = self.id == local.account_id
      error_message = "Failed to add account to cloudability. This could be caused by:"
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
    command = <<EOF
#!/bin/bash
ibmcloud login -a cloud.ibm.com --apikey ${var.ibmcloud_api_key}
timeout_seconds=1200 # 20 minutes
sleep_seconds=10
number_of_tries=$((timeout_seconds / sleep_seconds))
complete=false
for ((i = 1; i <= $number_of_tries; i++)); do
  count=$(($(ibmcloud cos objects --bucket "${self.triggers.bucket_name}" --prefix "${self.triggers.cos_bucket_prefix}" --region ${self.triggers.region} --json | jq -r  ".Contents? | length")+0))
  echo "Waiting for billing reports to exist in cos bucket `${self.triggers.bucket_name}`... ($${i}/$${number_of_tries})"
  if [[ count > 0 ]]; then
      complete=true
      break
  fi
  sleep $sleep_seconds
done
if ! $complete; then
  echo "Unable to successfully validate billing exports; Billing reports have not been added to the directory. Please try and running this again later."
  exit 1
fi

EOF
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
