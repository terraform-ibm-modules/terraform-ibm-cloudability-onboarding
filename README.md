<!-- Update this title with a descriptive name. Use sentence case. -->
# IBM Cloudability onboarding Deployable Architecture (DA)


<!--
Update status and "latest release" badges:
  1. For the status options, see https://terraform-ibm-modules.github.io/documentation/#/badge-status
  2. Update the "latest release" badge to point to the correct module's repo. Replace "terraform-ibm-module-template" in two places.
-->
[![Stable (With quality checks)](https://img.shields.io/badge/Status-Stable%20(With%20quality%20checks)-green)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-cloudability-onboarding?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-cloudability-onboarding/releases/latest)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

This Deployable Architecture will fully onboard a standard IBM Cloud account or an entire IBM Cloud enterprise to IBM Cloudability. The DA performs the following actions:

- Creates an encrypted COS bucket to store billing reports
- Enables daily Billing Report exports to the COS Bucket
- Grants Cloudability access to read the billing reports from the bucket for ingestion
    - *If the account is an enterprise*: Grants cloudability access to read the list of child accounts in the enterprise
    - Cloudability access is controlled in a custom role so only the minimum access is given.
- Adds the IBM Cloud account/enterprise to IBM Cloudability

:exclamation: **Important:** This Deployable Architecture solutions is not intended to be called by other modules because it contains a provider configuration and is therefor not compatible with the `for_each`, `count`, and `depends_on` arguments. For more information see [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)


<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-cloudability-onboarding](#terraform-ibm-cloudability-onboarding)
* [Submodules](./modules)
    * [billing-exports](./modules/billing-exports)
    * [cloudability-bucket-access](./modules/cloudability-bucket-access)
    * [cloudability-enterprise-access](./modules/cloudability-enterprise-access)
    * [cloudability-onboarding](./modules/cloudability-onboarding)
    * [data-resource-instance-by-id](./modules/data-resource-instance-by-id)
    * [encrypted_cos_bucket](./modules/encrypted_cos_bucket)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

<!--
If this repo contains any reference architectures, uncomment the heading below and link to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
## Reference architectures

![cloudability-all-inclusive-onboarding](./reference-architecture/cloudability-all-inclusive-onboarding.svg)

<!-- This heading should always match the name of the root level module (aka the repo name) -->
## terraform-ibm-cloudability-onboarding

### Required IAM access policies

<!-- PERMISSIONS REQUIRED TO RUN MODULE
If this module requires permissions, uncomment the following block and update
the sample permissions, following the format.
Replace the sample Account and IBM Cloud service names and roles with the
information in the console at
Manage > Access (IAM) > Access groups > Access policies.
-->


You need the following permissions to run this module:

- IAM services
    - **Cloud Object Storage** service
        - `Administrator` platform access
        - `Manager`, `ObjectReader` service access
    - **Key Protect** service
        - `Editor` platform access
        - `Manager` service access
- Account management services
    - **Billing** service
        - `Administrator` platform access
    - **Enterprise** service (only for enterprise accounts)
        - `Viewer` platform access
    - **IAM Access Management** service (only for enterprise accounts)
        - `Administrator` platform access

<!-- NO PERMISSIONS FOR MODULE
If no permissions are required for the module, uncomment the following
statement instead the previous block.
-->

<!-- No permissions are needed to run this module.-->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_cloudability"></a> [cloudability](#requirement\_cloudability) | 0.0.36 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.70.0 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | 1.20.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_exports"></a> [billing\_exports](#module\_billing\_exports) | ./modules/billing-exports | n/a |
| <a name="module_cloudability_bucket_access"></a> [cloudability\_bucket\_access](#module\_cloudability\_bucket\_access) | ./modules/cloudability-bucket-access | n/a |
| <a name="module_cloudability_enterprise_access"></a> [cloudability\_enterprise\_access](#module\_cloudability\_enterprise\_access) | ./modules/cloudability-enterprise-access | n/a |
| <a name="module_cloudability_onboarding"></a> [cloudability\_onboarding](#module\_cloudability\_onboarding) | ./modules/cloudability-onboarding | n/a |
| <a name="module_cos_bucket"></a> [cos\_bucket](#module\_cos\_bucket) | ./modules/encrypted_cos_bucket | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.1.6 |

### Resources

| Name | Type |
|------|------|
| [ibm_enterprises.enterprises](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.70.0/docs/data-sources/enterprises) | data source |
| [ibm_iam_account_settings.billing_exports_account](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.70.0/docs/data-sources/iam_account_settings) | data source |
| [ibm_iam_auth_token.tokendata](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.70.0/docs/data-sources/iam_auth_token) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the cos instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details | `list(string)` | `[]` | no |
| <a name="input_activity_tracker_crn"></a> [activity\_tracker\_crn](#input\_activity\_tracker\_crn) | The CRN of an Activity Tracker instance to send Object Storage bucket events to. If no value passed, events are sent to the instance associated to the container's location unless otherwise specified in the Activity Tracker Event Routing service configuration. | `string` | `null` | no |
| <a name="input_activity_tracker_management_events"></a> [activity\_tracker\_management\_events](#input\_activity\_tracker\_management\_events) | If set to true, all Object Storage management events will be sent to Activity Tracker. Only applies if `activity_tracker_crn` is not populated. | `bool` | `true` | no |
| <a name="input_activity_tracker_read_data_events"></a> [activity\_tracker\_read\_data\_events](#input\_activity\_tracker\_read\_data\_events) | If set to true, all Object Storage bucket read events (i.e. downloads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_activity_tracker_write_data_events"></a> [activity\_tracker\_write\_data\_events](#input\_activity\_tracker\_write\_data\_events) | If set to true, all Object Storage bucket write events (i.e. uploads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_add_bucket_name_suffix"></a> [add\_bucket\_name\_suffix](#input\_add\_bucket\_name\_suffix) | Add random generated suffix (4 characters long) to the newly provisioned COS bucket name (Optional). | `bool` | `true` | no |
| <a name="input_archive_days"></a> [archive\_days](#input\_archive\_days) | Specifies the number of days when the archive rule action takes effect. Only used if 'create\_cos\_bucket' is true. This must be set to null when when using var.cross\_region\_location as archive data is not supported with this feature. | `number` | `null` | no |
| <a name="input_archive_type"></a> [archive\_type](#input\_archive\_type) | Specifies the storage class or archive type to which you want the object to transition. Only used if 'create\_cos\_bucket' is true. | `string` | `"Glacier"` | no |
| <a name="input_bucket_cbr_rules"></a> [bucket\_cbr\_rules](#input\_bucket\_cbr\_rules) | (Optional, list) List of CBR rules to create for the bucket | <pre>list(object({<br/>    description = string<br/>    account_id  = string<br/>    rule_contexts = list(object({<br/>      attributes = optional(list(object({<br/>        name  = string<br/>        value = string<br/>    }))) }))<br/>    enforcement_mode = string<br/>    tags = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    operations = optional(list(object({<br/>      api_types = list(object({<br/>        api_type_id = string<br/>      }))<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name to give the newly provisioned COS bucket. Only required if 'create\_cos\_bucket' is true. | `string` | `"apptio-cldy-billing-snapshots"` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | the storage class of the newly provisioned COS bucket. Only required if 'create\_cos\_bucket' is true. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`. | `string` | `"standard"` | no |
| <a name="input_cloudability_api_key"></a> [cloudability\_api\_key](#input\_cloudability\_api\_key) | Cloudability API Key. Retrieve your Api Key from https://app.apptio.com/cloudability#/settings/preferences under the section **Cloudability API** select **Enable API** which will generate an api key. Setting this value to __NULL__ will skip adding the IBM Cloud account to Cloudability and only configure IBM Cloud so that the IBM Cloud Account can be added to Cloudability manually | `string` | `null` | no |
| <a name="input_cloudability_custom_role_name"></a> [cloudability\_custom\_role\_name](#input\_cloudability\_custom\_role\_name) | name of the custom role created access granted to cloudability service id to read from the billing reports cos bucket | `string` | `"CloudabilityStorageCustomRole"` | no |
| <a name="input_cloudability_enterprise_custom_role_name"></a> [cloudability\_enterprise\_custom\_role\_name](#input\_cloudability\_enterprise\_custom\_role\_name) | name of the custom role to granting access to a cloudability service id to read the enterprise information. Only used of var.is\_enterprise\_account is set. | `string` | `"CloudabilityListAccCustomRole"` | no |
| <a name="input_cloudability_host"></a> [cloudability\_host](#input\_cloudability\_host) | IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting_started_with_the_cloudability.htm#authentication | `string` | `"api.cloudability.com"` | no |
| <a name="input_cos_folder"></a> [cos\_folder](#input\_cos\_folder) | Folder in the COS bucket to store the account data | `string` | `"IBMCloud-Billing-Reports"` | no |
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The name to give the cloud object storage instance that will be provisioned by this module. Only required if 'create\_cos\_instance' is true. | `string` | `"ibm-cloudability"` | no |
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | Plan to be used for creating cloud object storage instance. Only used if 'create\_cos\_instance' it true. | `string` | `"standard"` | no |
| <a name="input_create_cos_instance"></a> [create\_cos\_instance](#input\_create\_cos\_instance) | Set as true to create a new Cloud Object Storage instance. | `bool` | `true` | no |
| <a name="input_create_key_protect_instance"></a> [create\_key\_protect\_instance](#input\_create\_key\_protect\_instance) | Key Protect instance name | `bool` | `true` | no |
| <a name="input_cross_region_location"></a> [cross\_region\_location](#input\_cross\_region\_location) | Specify the cross-regional bucket location. Supported values are 'us', 'eu', and 'ap'. If you pass a value for this, ensure to set the value of var.region to null. | `string` | `null` | no |
| <a name="input_enable_billing_exports"></a> [enable\_billing\_exports](#input\_enable\_billing\_exports) | Whether billing exports should be enabled | `bool` | `true` | no |
| <a name="input_enable_cloudability_access"></a> [enable\_cloudability\_access](#input\_enable\_cloudability\_access) | Whether to grant cloudability access to read the billing reports | `bool` | `true` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | Id of the enterprise. Can be automatically retrieved if `is_enterprise_account` is true | `string` | `null` | no |
| <a name="input_existing_cos_instance_id"></a> [existing\_cos\_instance\_id](#input\_existing\_cos\_instance\_id) | The ID of an existing cloud object storage instance. Required if 'var.create\_cos\_instance' is false. | `string` | `null` | no |
| <a name="input_existing_kms_instance_guid"></a> [existing\_kms\_instance\_guid](#input\_existing\_kms\_instance\_guid) | The GUID of the Key Protect or Hyper Protect instance in which the key specified in var.kms\_key\_crn is coming from. Required if var.skip\_iam\_authorization\_policy is false in order to create an IAM Access Policy to allow Key Protect or Hyper Protect to access the newly created COS instance. | `string` | `null` | no |
| <a name="input_expire_days"></a> [expire\_days](#input\_expire\_days) | Specifies the number of days when the expire rule action takes effect. Only used if 'create\_cos\_bucket' is true. | `number` | `null` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API key which will enable billing exports | `string` | n/a | yes |
| <a name="input_instance_cbr_rules"></a> [instance\_cbr\_rules](#input\_instance\_cbr\_rules) | (Optional, list) List of CBR rules to create for the instance | <pre>list(object({<br/>    description = string<br/>    account_id  = string<br/>    rule_contexts = list(object({<br/>      attributes = optional(list(object({<br/>        name  = string<br/>        value = string<br/>    }))) }))<br/>    enforcement_mode = string<br/>    tags = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })), [])<br/>    operations = optional(list(object({<br/>      api_types = list(object({<br/>        api_type_id = string<br/>      }))<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_is_enterprise_account"></a> [is\_enterprise\_account](#input\_is\_enterprise\_account) | Whether billing exports are enabled for the enterprise account | `bool` | `false` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the cos bucket encryption key | `string` | `null` | no |
| <a name="input_key_protect_instance_name"></a> [key\_protect\_instance\_name](#input\_key\_protect\_instance\_name) | Key Protect instance name | `string` | `"cloudability-bucket-encryption"` | no |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | Name of the key ring to group keys | `string` | `"bucket-encryption"` | no |
| <a name="input_management_endpoint_type_for_bucket"></a> [management\_endpoint\_type\_for\_bucket](#input\_management\_endpoint\_type\_for\_bucket) | The type of endpoint for the IBM terraform provider to use to manage the bucket. (public, private or direct) | `string` | `"public"` | no |
| <a name="input_monitoring_crn"></a> [monitoring\_crn](#input\_monitoring\_crn) | The CRN of an IBM Cloud Monitoring instance to to send Object Storage bucket metrics to. If no value passed, metrics are sent to the instance associated to the container's location unless otherwise specified in the Metrics Router service configuration. | `string` | `null` | no |
| <a name="input_object_versioning_enabled"></a> [object\_versioning\_enabled](#input\_object\_versioning\_enabled) | Enable object versioning to keep multiple versions of an object in a bucket. Cannot be used with retention rule. Only used if 'create\_cos\_bucket' is true. | `bool` | `false` | no |
| <a name="input_policy_granularity"></a> [policy\_granularity](#input\_policy\_granularity) | Whether access to the cos bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup). | `string` | `"resource"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where resources will be created | `string` | `"us-south"` | no |
| <a name="input_request_metrics_enabled"></a> [request\_metrics\_enabled](#input\_request\_metrics\_enabled) | If set to `true`, all Object Storage bucket request metrics will be sent to the monitoring service. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of an existing resource group to provision resources in to. | `string` | `"Default"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to be added to created resources | `list(string)` | `[]` | no |
| <a name="input_retention_default"></a> [retention\_default](#input\_retention\_default) | Specifies default duration of time an object that can be kept unmodified for COS bucket. Only used if 'create\_cos\_bucket' is true. | `number` | `90` | no |
| <a name="input_retention_enabled"></a> [retention\_enabled](#input\_retention\_enabled) | Retention enabled for COS bucket. Only used if 'create\_cos\_bucket' is true. | `bool` | `false` | no |
| <a name="input_retention_maximum"></a> [retention\_maximum](#input\_retention\_maximum) | Specifies maximum duration of time an object that can be kept unmodified for COS bucket. Only used if 'create\_cos\_bucket' is true. | `number` | `365` | no |
| <a name="input_retention_minimum"></a> [retention\_minimum](#input\_retention\_minimum) | Specifies minimum duration of time an object must be kept unmodified for COS bucket. Only used if 'create\_cos\_bucket' is true. | `number` | `1` | no |
| <a name="input_retention_permanent"></a> [retention\_permanent](#input\_retention\_permanent) | Specifies a permanent retention status either enable or disable for COS bucket. Only used if 'create\_cos\_bucket' is true. | `bool` | `false` | no |
| <a name="input_skip_cloudability_billing_policy"></a> [skip\_cloudability\_billing\_policy](#input\_skip\_cloudability\_billing\_policy) | Whether policy which grants cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run. | `bool` | `false` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits the COS instance created to read the encryption key from the KMS instance in `existing_kms_instance_guid`. WARNING: An authorization policy must exist before an encrypted bucket can be created | `bool` | `false` | no |
| <a name="input_skip_verification"></a> [skip\_verification](#input\_skip\_verification) | whether to verify the account after adding the account to cloudability. Requires cloudability\_auth\_header to be set. | `bool` | `false` | no |
| <a name="input_usage_metrics_enabled"></a> [usage\_metrics\_enabled](#input\_usage\_metrics\_enabled) | If set to `true`, all Object Storage bucket usage metrics will be sent to the monitoring service. | `bool` | `true` | no |
| <a name="input_use_existing_iam_custom_role"></a> [use\_existing\_iam\_custom\_role](#input\_use\_existing\_iam\_custom\_role) | Whether the iam\_custom\_roles should be created or if they already exist and the they should be linked with a datasource | `bool` | `false` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | Whether the value of `resource_group_name` input should be a new of existing resource\_group | `bool` | `true` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_account_cloudability_custom_role_display_name"></a> [bucket\_account\_cloudability\_custom\_role\_display\_name](#output\_bucket\_account\_cloudability\_custom\_role\_display\_name) | Display name of the custom role that grants cloudability access to read the billing reports from the cos bucket |
| <a name="output_bucket_cbr_rules"></a> [bucket\_cbr\_rules](#output\_bucket\_cbr\_rules) | COS bucket rules |
| <a name="output_bucket_crn"></a> [bucket\_crn](#output\_bucket\_crn) | Bucket CRN |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | Bucket id |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Bucket name |
| <a name="output_bucket_storage_class"></a> [bucket\_storage\_class](#output\_bucket\_storage\_class) | Bucket Storage Class |
| <a name="output_cbr_rule_ids"></a> [cbr\_rule\_ids](#output\_cbr\_rule\_ids) | List of all rule ids |
| <a name="output_cos_instance_guid"></a> [cos\_instance\_guid](#output\_cos\_instance\_guid) | The GUID of the Cloud Object Storage Instance where the buckets are created |
| <a name="output_cos_instance_id"></a> [cos\_instance\_id](#output\_cos\_instance\_id) | The ID of the Cloud Object Storage Instance where the buckets are created |
| <a name="output_enterprise_account_id"></a> [enterprise\_account\_id](#output\_enterprise\_account\_id) | primary account id of the enterprise if `is_enterprise_account` is enabled |
| <a name="output_enterprise_cloudability_custom_role_display_name"></a> [enterprise\_cloudability\_custom\_role\_display\_name](#output\_enterprise\_cloudability\_custom\_role\_display\_name) | Display name of the custom role that grants cloudability access to read the enterprise accounts |
| <a name="output_enterprise_id"></a> [enterprise\_id](#output\_enterprise\_id) | id of the enterprise if `is_enterprise_account` is enabled |
| <a name="output_instance_cbr_rules"></a> [instance\_cbr\_rules](#output\_instance\_cbr\_rules) | COS instance rules |
| <a name="output_key_protect_guid"></a> [key\_protect\_guid](#output\_key\_protect\_guid) | Key Protect GUID |
| <a name="output_key_protect_id"></a> [key\_protect\_id](#output\_key\_protect\_id) | Key Protect service instance ID when an instance is created, otherwise null |
| <a name="output_key_protect_instance_policies"></a> [key\_protect\_instance\_policies](#output\_key\_protect\_instance\_policies) | Instance Polices of the Key Protect instance |
| <a name="output_key_protect_name"></a> [key\_protect\_name](#output\_key\_protect\_name) | Key Protect Name |
| <a name="output_key_rings"></a> [key\_rings](#output\_key\_rings) | IDs of new Key Rings created by the module |
| <a name="output_keys"></a> [keys](#output\_keys) | IDs of new Keys created by the module |
| <a name="output_kms_key_crn"></a> [kms\_key\_crn](#output\_kms\_key\_crn) | The CRN of the KMS key used to encrypt the COS bucket |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | Resource Group ID |
| <a name="output_s3_endpoint_public"></a> [s3\_endpoint\_public](#output\_s3\_endpoint\_public) | S3 public endpoint |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
