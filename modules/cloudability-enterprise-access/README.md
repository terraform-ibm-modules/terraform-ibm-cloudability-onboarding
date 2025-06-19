# cloudability enterprise access module

<!-- Add a description of module(s) in this repo -->
This module grants the IBM Cloudability ServiceID access to read the list of enterprise accounts in the case that the IBM Cloud account is [an Enterprise](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-what-is-enterprise. The module uses [iam custom roles](https://cloud.ibm.com/docs/account?topic=account-custom-roles&interface=ui) so that Apptio cloudability has only the minimum required access to the storage bucket.

The policies are granted directly to the ServiceId.

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_iam_custom_role.list_enterprise_custom_role](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_custom_role) | resource |
| [ibm_iam_service_policy.billing_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_service_policy.enterprise_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_roles.list_enterprise_custom_role](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_roles) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudability_iam_custom_role_name"></a> [cloudability\_iam\_custom\_role\_name](#input\_cloudability\_iam\_custom\_role\_name) | Name of the custom role which grants access to the Cloudability service ID to read the enterprise information. Only used if `is_enterprise_account` is `true`. | `string` | `"CloudabilityListAccCustomRole"` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | Guid for the enterprise account id | `string` | `null` | no |
| <a name="input_skip_cloudability_billing_policy"></a> [skip\_cloudability\_billing\_policy](#input\_skip\_cloudability\_billing\_policy) | Whether policy which grants cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run. | `bool` | `false` | no |
| <a name="input_use_existing_iam_custom_role"></a> [use\_existing\_iam\_custom\_role](#input\_use\_existing\_iam\_custom\_role) | Whether the iam\_custom\_roles should be created or if they already exist and they should be linked with a datasource | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_billing_policy"></a> [billing\_policy](#output\_billing\_policy) | The policy granted to the ServiceId for reading billing |
| <a name="output_custom_role_display_name"></a> [custom\_role\_display\_name](#output\_custom\_role\_display\_name) | Display name of the enterprise custom role to read the list of enterprise custom accounts |
| <a name="output_enterprise_policy"></a> [enterprise\_policy](#output\_enterprise\_policy) | The policy granted to the ServiceId to read the enterprise |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
