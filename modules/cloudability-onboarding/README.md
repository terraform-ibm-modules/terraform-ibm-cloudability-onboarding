<!-- Update the title -->
# cloudability-onboarding module

<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-module-template?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-module-template/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)


<!-- Add a description of module(s) in this repo -->
This module adds an IBM Cloud account to Cloudability by gathering all of the required data for the request, validating that the bucket contains the billing files, and then verifying from the cloudability that it has the access it requires to access the files.


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [cloudability onboarding module](#cloudability-onboarding-module)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


### Compliance and security
<!--
The following 'Compliance and security' section
is for the GoldenEye core team only.
-->

<!-- MODULE IMPLEMENTS CONTROLS
If the module implements NIST controls,
uncomment the following block and update the information.
-->

<!--
This module implements the following NIST controls. For more information about how this module implements the controls in the following list, see [NIST controls](docs/controls.md).

| Profile | Category | ID       | Description |
|---------|----------|----------|-------------|
| NIST    | SC-7     | SC-7(3)  | Limit the number of external network connections to the information system. |

The 'Profile' and 'ID' columns are used by the IBM Cloud catalog to import
the controls into the catalog page.

In the example here, remove the SC-7 row and include a row for each control
that the module implements.

Include the control enhancement in the ID column ('SC-7(3)' in this example).

Identify how the module is complying with the controls. Summarize the
rationale or implementation in the 'Description' column.

For details about the controls, see the NIST Risk Management Framework page at
https://csrc.nist.gov/Projects/risk-management/sp800-53-controls/release-search#/controls?version=4.0.
-->

<!-- NO CONTROLS FOR MODULE
However, if the module requires a section about controls
but no controls are implemented by the module,
uncomment the following block instead of the previous one.
-->

<!--
NIST controls do not apply to this module.
-->

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
module "cloudability_onboarding" {
  source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-apptio-cloudability-onboarding//modules/cloudability-onboarding"

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_cloudability"></a> [cloudability](#requirement\_cloudability) | >= 0.0.35 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | >= 1.18.2 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cos_instance"></a> [cos\_instance](#module\_cos\_instance) | ../data-resource-instance-by-id | n/a |

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
| <a name="input_cloudability_host"></a> [cloudability\_host](#input\_cloudability\_host) | Apptio Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting_started_with_the_cloudability.htm#authentication | `string` | `"api.cloudability.com"` | no |
| <a name="input_cos_bucket_crn"></a> [cos\_bucket\_crn](#input\_cos\_bucket\_crn) | CRN of the COS bucket | `string` | n/a | yes |
| <a name="input_cos_bucket_location"></a> [cos\_bucket\_location](#input\_cos\_bucket\_location) | Location of the cos bucket. | `string` | n/a | yes |
| <a name="input_cos_bucket_prefix"></a> [cos\_bucket\_prefix](#input\_cos\_bucket\_prefix) | name of the manifest file in the cost report | `string` | `"IBMCloud-Billing-Reports"` | no |
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The name to give the cloud object storage instance that will be provisioned by this module. If not specified then the instance name is retrieved from the instance crn from the bucket | `string` | `null` | no |
| <a name="input_cost_report_name"></a> [cost\_report\_name](#input\_cost\_report\_name) | name of the manifest file in the cost report | `string` | `"manifest"` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | Guid for the enterprise id | `string` | `""` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API Key | `string` | n/a | yes |
| <a name="input_skip_verification"></a> [skip\_verification](#input\_skip\_verification) | whether to verify the account after adding the account to cloudability. Requires cloudability\_auth\_header to be set. | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudability_account_verification_state"></a> [cloudability\_account\_verification\_state](#output\_cloudability\_account\_verification\_state) | Current state of the cloudability account verification if var.skip\_verification is enabled |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
