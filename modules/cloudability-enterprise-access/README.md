# cloudability enterprise access module

<!-- Add a description of module(s) in this repo -->
This module grants the Apptio Cloudability ServiceID access to read the list of enterprise accounts in the case that the IBM Cloud account is [an Enterprise](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-what-is-enterprise. The module uses [iam custom roles](https://cloud.ibm.com/docs/account?topic=account-custom-roles&interface=ui) so that Apptio cloudability has only the minimum required access to the storage bucket.

The policies are granted directly to the ServiceId.

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
