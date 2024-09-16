<!-- Update the title -->
# Apptio cloudability COS bucket access

<!-- Add a description of module(s) in this repo -->
This module grants the Apptio Cloudability ServiceID access to the bucket containing the billing exports (see [Exporting your usage data for continual insights](https://cloud.ibm.com/docs/billing-usage?topic=billing-usage-exporting-your-usage&interface=terraform)). The module uses [iam custom roles](https://cloud.ibm.com/docs/account?topic=account-custom-roles&interface=ui) so that Apptio cloudability has only the minimum required access to the storage bucket.

The policies are granted directly to the ServiceId

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->


```hcl
data "ibm_resource_group" "group" {
  name = "test"
}

module "cloudability_bucket_access" {
  source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-apptio-cloudability-onboarding//modules/cloudability-bucket-access"
  bucket_crn                    = "crn:v1:bluemix:public:cloud-object-storage:global:a/81ee25188545f05150650a0a4ee015bb:a2deec95-0836-4720-bfc7-ca41c28a8c66:bucket:tf-listbuckettest"
  resource_group_id             = data.ibm_resource_group.group.id
  policy_granularity            = "resource"
  cloudability_custom_role_name = "CloudabilityStorageCustomRole"
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
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_iam_custom_role.cos_custom_role](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_custom_role) | resource |
| [ibm_iam_service_policy.cos_bucket_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_service_policy.cos_instance_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |
| [ibm_iam_service_policy.cos_resource_group_policy](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_service_policy) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_crn"></a> [bucket\_crn](#input\_bucket\_crn) | crn of the cos bucket. Required if policy\_granularity is `resource` or `instance` | `string` | `null` | no |
| <a name="input_cloudability_custom_role_name"></a> [cloudability\_custom\_role\_name](#input\_cloudability\_custom\_role\_name) | name of the custom role created access granted to cloudability service id to read from the billing reports cos bucket | `string` | `"CloudabilityStorageCustomRole"` | no |
| <a name="input_policy_granularity"></a> [policy\_granularity](#input\_policy\_granularity) | Whether access to the cos bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup). Note: `resource_group_id` is required in the case of the `resourceGroup`. `bucket_crn` is required otherwise. | `string` | `"resource"` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group that the cos buckets are deployed in. Required if `policy_granularity` is "resource-group". Not used otherwise. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_role_display_name"></a> [custom\_role\_display\_name](#output\_custom\_role\_display\_name) | Display name of the cos custom role |
| <a name="output_service_policy"></a> [service\_policy](#output\_service\_policy) | The policy granted to the ServiceId |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
