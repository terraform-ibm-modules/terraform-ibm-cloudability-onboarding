<!-- Update the title -->
# cloudability-onboarding module

<!-- Add a description of module(s) in this repo -->
This module adds an IBM Cloud account to Cloudability by gathering all of the required data for the request, validating that the bucket contains the billing files, and then verifying from the cloudability that it has the access it requires to access the files.

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
module "cloudability_onboarding" {
  source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cloudability-onboarding//modules/cloudability-onboarding"

  ibmcloud_api_key    = "XXXXXXXXXX"
  cos_bucket_prefix   = "IBMCloud-Billing-Reports"
  cos_bucket_location = "us-south"
  cos_bucket_crn      = "crn:v1:bluemix:public:cloud-object-storage:global:a/81ee25188545f05150650a0a4ee015bb:a2deec95-0836-4720-bfc7-ca41c28a8c66:bucket:tf-listbuckettest"
  enterprise_id       = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
  skip_verification   = false
  cloudability_host = "api.cloudability.com"
}
```

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->

<!--
You need the following permissions to run this module.

- Account Management
    - **Sample Account Service** service
        - `Editor` platform access
        - `Manager` service access
    - IAM Services
        - **Sample Cloud Service** service
            - `Administrator` platform access
-->

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0 |
| <a name="requirement_cloudability"></a> [cloudability](#requirement\_cloudability) | >= 0.0.35, <1.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, <2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2, <4.0.0 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 2.0.0, <3.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [null_resource.wait_for_billing_exports](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [restapi_object.cloudability_ibm_account](https://registry.terraform.io/providers/Mastercard/restapi/latest/docs/resources/object) | resource |
| [cloudability_account_verification.ibm_account](https://registry.terraform.io/providers/skyscrapr/cloudability/latest/docs/data-sources/account_verification) | data source |
| [ibm_iam_account_settings.account](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_account_settings) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudability_host"></a> [cloudability\_host](#input\_cloudability\_host) | IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting%20started%20with%20the%20cloudability.htm | `string` | `"api.cloudability.com"` | no |
| <a name="input_cos_bucket_crn"></a> [cos\_bucket\_crn](#input\_cos\_bucket\_crn) | CRN of the Object Storage bucket | `string` | n/a | yes |
| <a name="input_cos_bucket_location"></a> [cos\_bucket\_location](#input\_cos\_bucket\_location) | Location of the Object Storage bucket. | `string` | n/a | yes |
| <a name="input_cos_bucket_prefix"></a> [cos\_bucket\_prefix](#input\_cos\_bucket\_prefix) | name of the manifest file in the cost report | `string` | `"IBMCloud-Billing-Reports"` | no |
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The name to give the Cloud Object Storage instance that will be provisioned by this module. If not specified then the instance name is retrieved from the instance crn from the bucket | `string` | `null` | no |
| <a name="input_cost_report_name"></a> [cost\_report\_name](#input\_cost\_report\_name) | name of the manifest file in the cost report | `string` | `"manifest"` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | Guid for the enterprise id | `string` | `""` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API Key | `string` | n/a | yes |
| <a name="input_skip_verification"></a> [skip\_verification](#input\_skip\_verification) | whether to verify the account after adding the account to cloudability. | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudability_account_verification_state"></a> [cloudability\_account\_verification\_state](#output\_cloudability\_account\_verification\_state) | Current state of the cloudability account verification if var.skip\_verification is enabled |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
