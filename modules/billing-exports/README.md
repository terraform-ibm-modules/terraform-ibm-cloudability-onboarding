<!-- Update the title -->
# Billing exports module

This module configures the exporting of billing and usage files to a IBM Cloud object storage bucket as discussed in the IBM Cloud doc: "[Exporting your usage data for continual insights](https://cloud.ibm.com/docs/billing-usage?topic=billing-usage-exporting-your-usage&interface=terraform)"

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

module "billing_exports" {
  source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cloudability-onboarding//modules/billing-exports"
  cos_bucket_crn      = "crn:v1:bluemix:public:cloud-object-storage:global:a/81ee25188545f05150650a0a4ee015bb:a2deec95-0836-4720-bfc7-ca41c28a8c66:bucket:tf-listbuckettest"
  cos_bucket_location = "us-south"
  interval            = "daily"
  cos_folder          = "Billing-Report-Snapshots"
  report_types        = var.billing_export_report_types
  versioning          = "new"
  resource_group_id   = data.ibm_resource_group.group.id
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, <2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.2, <4.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1, <1.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_billing_report_snapshot.billing_report_snapshot_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/billing_report_snapshot) | resource |
| [ibm_iam_authorization_policy.billing_to_cos_authorization](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/iam_authorization_policy) | resource |
| [null_resource.billing_report_replacement_trigger](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.wait_for_authorization_policy](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [ibm_iam_account_settings.iam_account_settings](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/iam_account_settings) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | Account id which billing exports are enabled in. Defaults to the account id of the api key | `string` | `null` | no |
| <a name="input_cos_bucket_crn"></a> [cos\_bucket\_crn](#input\_cos\_bucket\_crn) | CRN of the Object Storage bucket | `string` | n/a | yes |
| <a name="input_cos_bucket_location"></a> [cos\_bucket\_location](#input\_cos\_bucket\_location) | location of the Object Storage bucket | `string` | n/a | yes |
| <a name="input_cos_folder"></a> [cos\_folder](#input\_cos\_folder) | Folder in the Object Storage bucket to store the account data | `string` | `"IBMCloud-Billing-Reports"` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | Billing granularity | `string` | `"daily"` | no |
| <a name="input_report_types"></a> [report\_types](#input\_report\_types) | billing report types | `list(string)` | `null` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | resource\_group\_id for the polcicy creation of the service to service authorization | `string` | `null` | no |
| <a name="input_skip_authorization_policy"></a> [skip\_authorization\_policy](#input\_skip\_authorization\_policy) | Whether to skip the authorization policy. May be used when deploying across accounts. | `bool` | `false` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Add new reports or overwrite existing reports | `string` | `"overwrite"` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_export_account_type"></a> [export\_account\_type](#output\_export\_account\_type) | Date that the exports were last updated |
| <a name="output_export_compression"></a> [export\_compression](#output\_export\_compression) | type of compression for the exports |
| <a name="output_export_content_type"></a> [export\_content\_type](#output\_export\_content\_type) | The content type of the billing exports. default is text/csv |
| <a name="output_export_cos_write_location"></a> [export\_cos\_write\_location](#output\_export\_cos\_write\_location) | COS url to the write location |
| <a name="output_export_state"></a> [export\_state](#output\_export\_state) | The current state of the billing exports. Either enabled or disabled. |
| <a name="output_id"></a> [id](#output\_id) | The unique identifier of the billing\_report\_snapshot. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
