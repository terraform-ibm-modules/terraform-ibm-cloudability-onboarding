# cloudability enterprise access module

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
This module grants the Apptio Cloudability ServiceID access to read the list of enterprise accounts in the case that the IBM Cloud account is [an Enterprise](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-what-is-enterprise. The module uses [iam custom roles](https://cloud.ibm.com/docs/account?topic=account-custom-roles&interface=ui) so that Apptio cloudability has only the minimum required access to the storage bucket.

The policies are granted directly to the ServiceId.


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [cloudability enterprise access module](#cloudability-enterprise-access-module)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_iam_custom_role.list_enterprise_custom_role](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_custom_role) | resource |
| [ibm_iam_service_policy.billing_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_service_policy.enterprise_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudability_custom_role_name"></a> [cloudability\_custom\_role\_name](#input\_cloudability\_custom\_role\_name) | name of the custom role to granting access to a cloudability service id to read the enterprise information | `string` | `"CloudabilityListAccCustomRole"` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | Guid for the enterprise account id | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_policy"></a> [billing\_policy](#output\_billing\_policy) | The policy granted to the ServiceId for reading billing |
| <a name="output_custom_role_display_name"></a> [custom\_role\_display\_name](#output\_custom\_role\_display\_name) | Display name of the enterprise custom role to read the list of enterprise custom accounts |
| <a name="output_enterprise_policy"></a> [enterprise\_policy](#output\_enterprise\_policy) | The policy granted to the ServiceId to read the enterprise |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
