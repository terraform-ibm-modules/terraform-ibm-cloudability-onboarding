<!-- Update the title -->
# data-resource-instance-by-id module

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
This module is a meant to supplement the IBM Cloud terraform provider as a data source for requesting the resource information by the id. There is a [`ibm_resource_instance`](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_instance) which accepts the name of the resource but sometimes (such as the case when only given a crn) you don't know the name but you know the id and the name is what you are trying to retrieve.


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [data-resource-instance-by-id-module](#data-resource-instance-by-id-module)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


## Compliance and security
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
module "cos_instance" {
    source              = "git::https://github.ibm.com/dataops/terraform-billing-reports-snapshot-module//modules/data-resource-instance-by-id"
    guid   = "a2deec95-0836-4720-bfc7-ca41c28a8c66"
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


<!-- Below content is automatically populated via pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.4.1 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [http_http.resource_instance](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [ibm_iam_auth_token.tokendata](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_auth_token) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_guid"></a> [guid](#input\_guid) | The guid of the resource instance | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_crn"></a> [crn](#output\_crn) | crn of the resource instance |
| <a name="output_name"></a> [name](#output\_name) | name of the resource instance |
| <a name="output_region_id"></a> [region\_id](#output\_region\_id) | region\_id of the resource instance |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | region\_id of the resource instance |
| <a name="output_resource_plan_id"></a> [resource\_plan\_id](#output\_resource\_plan\_id) | resource\_plan\_id of the resource instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
