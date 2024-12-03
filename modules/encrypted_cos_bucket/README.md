<!-- Update the title -->
# Encrypted Object Storage bucket module

<!-- Add a description of module(s) in this repo -->
All in one module for creating a Key protect, COS instance and a Object Storage bucket that is encrypted with a key from Key Protect.

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
# Creates:
# - COS instance
# - Key Protect instance
# - COS buckets with retention, encryption
module "cos_bucket" {
    source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cloudability-onboarding//modules/encrypted_cos_bucket"
    resource_group_id          = "xxXXxxXXxXxXXXXxxXxxxXXXXxXXXXX"
    region                     = "us-south"
    cos_instance_name          = "my-cos-instance"
    bucket_name                = "my-cos-bucket"
    key_protect_instance_name           = "my-key-protect-instance"
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
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cos_bucket"></a> [cos\_bucket](#module\_cos\_bucket) | terraform-ibm-modules/cos/ibm | 8.15.2 |
| <a name="module_key_protect_all_inclusive"></a> [key\_protect\_all\_inclusive](#module\_key\_protect\_all\_inclusive) | terraform-ibm-modules/kms-all-inclusive/ibm | 4.17.0 |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the cos instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details | `list(string)` | `[]` | no |
| <a name="input_activity_tracker_management_events"></a> [activity\_tracker\_management\_events](#input\_activity\_tracker\_management\_events) | If set to true, all Object Storage management events will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_activity_tracker_read_data_events"></a> [activity\_tracker\_read\_data\_events](#input\_activity\_tracker\_read\_data\_events) | If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_activity_tracker_write_data_events"></a> [activity\_tracker\_write\_data\_events](#input\_activity\_tracker\_write\_data\_events) | If set to true, all Object Storage bucket write events (uploads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_add_bucket_name_suffix"></a> [add\_bucket\_name\_suffix](#input\_add\_bucket\_name\_suffix) | Add random generated suffix (4 characters long) to the newly provisioned Object Storage bucket name (Optional). | `bool` | `false` | no |
| <a name="input_archive_days"></a> [archive\_days](#input\_archive\_days) | Specifies the number of days when the archive rule action takes effect. This must be set to null when when using var.cross\_region\_location as archive data is not supported with this feature. | `number` | `null` | no |
| <a name="input_archive_type"></a> [archive\_type](#input\_archive\_type) | Specifies the storage class or archive type to which you want the object to transition. | `string` | `"Glacier"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name to give the newly provisioned Object Storage bucket. | `string` | `"snapshots"` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | the storage class of the newly provisioned Object Storage bucket. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`. | `string` | `"standard"` | no |
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The name to give the Cloud Object Storage instance that will be provisioned by this module. Only required if 'create\_cos\_instance' is true. | `string` | `"billing_snapshots"` | no |
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | Plan to be used for creating Cloud Object Storage instance. Only used if 'create\_cos\_instance' it true. | `string` | `"standard"` | no |
| <a name="input_create_cos_instance"></a> [create\_cos\_instance](#input\_create\_cos\_instance) | Set as true to create a new Cloud Object Storage instance. | `bool` | `true` | no |
| <a name="input_create_key_protect_instance"></a> [create\_key\_protect\_instance](#input\_create\_key\_protect\_instance) | Key Protect instance name | `bool` | `true` | no |
| <a name="input_cross_region_location"></a> [cross\_region\_location](#input\_cross\_region\_location) | Specify the cross-regional bucket location. Supported values are 'us', 'eu', and 'ap'. If you pass a value for this, ensure to set the value of var.region to null. | `string` | `null` | no |
| <a name="input_existing_cos_instance_id"></a> [existing\_cos\_instance\_id](#input\_existing\_cos\_instance\_id) | The ID of an existing Cloud Object Storage instance. Required if 'var.create\_cos\_instance' is false. | `string` | `null` | no |
| <a name="input_existing_kms_instance_crn"></a> [existing\_kms\_instance\_crn](#input\_existing\_kms\_instance\_crn) | The CRN of an existing Key Protect or Hyper Protect Crypto Services instance. Required if 'create\_key\_protect\_instance' is false. | `string` | `null` | no |
| <a name="input_expire_days"></a> [expire\_days](#input\_expire\_days) | Specifies the number of days when the expire rule action takes effect. | `number` | `null` | no |
| <a name="input_key_endpoint_type"></a> [key\_endpoint\_type](#input\_key\_endpoint\_type) | The type of endpoint to be used for creating keys. Accepts 'public' or 'private' | `string` | `"public"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the Object Storage bucket encryption key | `string` | `null` | no |
| <a name="input_key_protect_allowed_network"></a> [key\_protect\_allowed\_network](#input\_key\_protect\_allowed\_network) | The type of the allowed network to be set for the Key Protect instance. Possible values are 'private-only', or 'public-and-private'. Only used if 'create\_key\_protect\_instance' is true. | `string` | `"public-and-private"` | no |
| <a name="input_key_protect_instance_name"></a> [key\_protect\_instance\_name](#input\_key\_protect\_instance\_name) | Key Protect instance name | `string` | `null` | no |
| <a name="input_key_ring_endpoint_type"></a> [key\_ring\_endpoint\_type](#input\_key\_ring\_endpoint\_type) | The type of endpoint to be used for creating key rings. Accepts 'public' or 'private' | `string` | `"public"` | no |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | Name of the key ring to group keys | `string` | `"bucket-encryption"` | no |
| <a name="input_management_endpoint_type_for_bucket"></a> [management\_endpoint\_type\_for\_bucket](#input\_management\_endpoint\_type\_for\_bucket) | The type of endpoint for the IBM terraform provider to use to manage the bucket. (public, private, or direct) | `string` | `"public"` | no |
| <a name="input_monitoring_crn"></a> [monitoring\_crn](#input\_monitoring\_crn) | The CRN of an IBM Cloud Monitoring instance to send Object Storage bucket metrics to. If no value passed, metrics are sent to the instance associated to the container's location unless otherwise specified in the Metrics Router service configuration. | `string` | `null` | no |
| <a name="input_object_versioning_enabled"></a> [object\_versioning\_enabled](#input\_object\_versioning\_enabled) | Enable object versioning to keep multiple versions of an object in a bucket. | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where resources are created | `string` | `"us-south"` | no |
| <a name="input_request_metrics_enabled"></a> [request\_metrics\_enabled](#input\_request\_metrics\_enabled) | If set to `true`, all Object Storage bucket request metrics will be sent to the monitoring service. | `bool` | `true` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The resource group ID where resources will be provisioned. | `string` | n/a | yes |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to be added to created resources | `list(string)` | `[]` | no |
| <a name="input_retention_default"></a> [retention\_default](#input\_retention\_default) | Specifies default duration of time an object that can be kept unmodified for Object Storage bucket. | `number` | `90` | no |
| <a name="input_retention_enabled"></a> [retention\_enabled](#input\_retention\_enabled) | Retention enabled for Object Storage bucket. | `bool` | `false` | no |
| <a name="input_retention_maximum"></a> [retention\_maximum](#input\_retention\_maximum) | Specifies maximum duration of time an object that can be kept unmodified for Object Storage bucket. | `number` | `350` | no |
| <a name="input_retention_minimum"></a> [retention\_minimum](#input\_retention\_minimum) | Specifies minimum duration of time an object must be kept unmodified for Object Storage bucket. | `number` | `90` | no |
| <a name="input_retention_permanent"></a> [retention\_permanent](#input\_retention\_permanent) | Specifies a permanent retention status either enable or disable for Object Storage bucket. | `bool` | `false` | no |
| <a name="input_rotation_enabled"></a> [rotation\_enabled](#input\_rotation\_enabled) | If set to true, Key Protect enables a rotation policy on the Key Protect instance. Only used if 'create\_key\_protect\_instance' is true. | `bool` | `true` | no |
| <a name="input_rotation_interval_month"></a> [rotation\_interval\_month](#input\_rotation\_interval\_month) | Specifies the number of months for the encryption key to be rotated.. Must be between 1 and 12 inclusive. Only used if 'create\_key\_protect\_instance' is true. | `number` | `1` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance in `existing_kms_instance_crn`. WARNING: An authorization policy must exist before an encrypted bucket can be created | `bool` | `false` | no |
| <a name="input_usage_metrics_enabled"></a> [usage\_metrics\_enabled](#input\_usage\_metrics\_enabled) | If set to `true`, all Object Storage bucket usage metrics will be sent to the monitoring service. | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_crn"></a> [bucket\_crn](#output\_bucket\_crn) | Bucket CRN |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket id |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Bucket name |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | Bucket region if you create a regional bucket |
| <a name="output_bucket_storage_class"></a> [bucket\_storage\_class](#output\_bucket\_storage\_class) | Bucket Storage Class |
| <a name="output_cos_instance_guid"></a> [cos\_instance\_guid](#output\_cos\_instance\_guid) | The GUID of the Cloud Object Storage Instance where the buckets are created |
| <a name="output_cos_instance_id"></a> [cos\_instance\_id](#output\_cos\_instance\_id) | The ID of the Cloud Object Storage Instance where the buckets are created |
| <a name="output_key_protect_guid"></a> [key\_protect\_guid](#output\_key\_protect\_guid) | ID of the Key Protect instance which contains the encryption key for the object storage bucket |
| <a name="output_key_protect_instance_policies"></a> [key\_protect\_instance\_policies](#output\_key\_protect\_instance\_policies) | Instance Polices of the Key Protect instance |
| <a name="output_key_protect_name"></a> [key\_protect\_name](#output\_key\_protect\_name) | Key Protect Name |
| <a name="output_key_rings"></a> [key\_rings](#output\_key\_rings) | IDs of new Key Rings created by the module |
| <a name="output_keys"></a> [keys](#output\_keys) | IDs of new Keys created by the module |
| <a name="output_kms_crn"></a> [kms\_crn](#output\_kms\_crn) | CRN of the KMS instance when an instance |
| <a name="output_kms_key_crn"></a> [kms\_key\_crn](#output\_kms\_key\_crn) | The CRN of the KMS key used to encrypt the Object Storage bucket |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | Resource Group ID |
| <a name="output_s3_endpoint_direct"></a> [s3\_endpoint\_direct](#output\_s3\_endpoint\_direct) | S3 direct endpoint |
| <a name="output_s3_endpoint_private"></a> [s3\_endpoint\_private](#output\_s3\_endpoint\_private) | S3 private endpoint |
| <a name="output_s3_endpoint_public"></a> [s3\_endpoint\_public](#output\_s3\_endpoint\_public) | S3 public endpoint |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
