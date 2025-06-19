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

- Creates an encrypted Object Storage bucket to store billing reports
- Enables daily Billing Report exports to the Object Storage bucket
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
    * [frontdoor-opentoken](./modules/frontdoor-opentoken)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

<!--
If this repo contains any reference architectures, uncomment the heading below and link to them.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->
## Reference architectures

![cloudability-all-inclusive-onboarding](./reference-architectures/cloudability-all-inclusive-onboarding.svg)

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
    - **Enterprise** service (only for enterprise accounts ie. `is_enterprise_account` is true)
        - `Administrator` platform access
    - **IAM Access Management** service
        - `Administrator` platform access
    - **All Account Management** service (only if `use_existing_resource_group` is true)
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0 |
| <a name="requirement_cloudability"></a> [cloudability](#requirement\_cloudability) | 0.0.40 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.77.1 |
| <a name="requirement_restapi"></a> [restapi](#requirement\_restapi) | 1.20.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_billing_exports"></a> [billing\_exports](#module\_billing\_exports) | ./modules/billing-exports | n/a |
| <a name="module_cbr_zone_additional"></a> [cbr\_zone\_additional](#module\_cbr\_zone\_additional) | terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module | 1.29.0 |
| <a name="module_cbr_zone_cloudability"></a> [cbr\_zone\_cloudability](#module\_cbr\_zone\_cloudability) | terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module | 1.29.0 |
| <a name="module_cbr_zone_cos"></a> [cbr\_zone\_cos](#module\_cbr\_zone\_cos) | terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module | 1.29.0 |
| <a name="module_cbr_zone_ibmcloud_billing"></a> [cbr\_zone\_ibmcloud\_billing](#module\_cbr\_zone\_ibmcloud\_billing) | terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module | 1.29.0 |
| <a name="module_cbr_zone_schematics"></a> [cbr\_zone\_schematics](#module\_cbr\_zone\_schematics) | terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module | 1.29.0 |
| <a name="module_cloudability_bucket_access"></a> [cloudability\_bucket\_access](#module\_cloudability\_bucket\_access) | ./modules/cloudability-bucket-access | n/a |
| <a name="module_cloudability_enterprise_access"></a> [cloudability\_enterprise\_access](#module\_cloudability\_enterprise\_access) | ./modules/cloudability-enterprise-access | n/a |
| <a name="module_cloudability_onboarding"></a> [cloudability\_onboarding](#module\_cloudability\_onboarding) | ./modules/cloudability-onboarding | n/a |
| <a name="module_cos_bucket"></a> [cos\_bucket](#module\_cos\_bucket) | ./modules/encrypted_cos_bucket | n/a |
| <a name="module_cos_instance"></a> [cos\_instance](#module\_cos\_instance) | ./modules/data-resource-instance-by-id | n/a |
| <a name="module_frontdoor_auth"></a> [frontdoor\_auth](#module\_frontdoor\_auth) | ./modules/frontdoor-opentoken | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.2.0 |

### Resources

| Name | Type |
|------|------|
| [ibm_enterprises.enterprises](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.77.1/docs/data-sources/enterprises) | data source |
| [ibm_iam_account_settings.billing_exports_account](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.77.1/docs/data-sources/iam_account_settings) | data source |
| [ibm_iam_auth_token.tokendata](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.77.1/docs/data-sources/iam_auth_token) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_tags"></a> [access\_tags](#input\_access\_tags) | A list of access tags to apply to the cos instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details | `list(string)` | `[]` | no |
| <a name="input_activity_tracker_management_events"></a> [activity\_tracker\_management\_events](#input\_activity\_tracker\_management\_events) | If set to true, all Object Storage management events will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_activity_tracker_read_data_events"></a> [activity\_tracker\_read\_data\_events](#input\_activity\_tracker\_read\_data\_events) | If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_activity_tracker_write_data_events"></a> [activity\_tracker\_write\_data\_events](#input\_activity\_tracker\_write\_data\_events) | If set to true, all Object Storage bucket read events (downloads) will be sent to Activity Tracker. | `bool` | `true` | no |
| <a name="input_add_bucket_name_suffix"></a> [add\_bucket\_name\_suffix](#input\_add\_bucket\_name\_suffix) | Add random generated suffix (4 characters long) to the newly provisioned Object Storage bucket name (Optional). | `bool` | `true` | no |
| <a name="input_additional_allowed_cbr_bucket_ip_addresses"></a> [additional\_allowed\_cbr\_bucket\_ip\_addresses](#input\_additional\_allowed\_cbr\_bucket\_ip\_addresses) | A list of CBR zone IP addresses, which are permitted to access the bucket.  This zone typically represents the IP addresses for your company or workstation to allow access to view the contents of the bucket. | `list(string)` | `[]` | no |
| <a name="input_archive_days"></a> [archive\_days](#input\_archive\_days) | Specifies the number of days when the archive rule action takes effect. A value of `null` disables archiving. A value of `0` immediately archives uploaded objects to the bucket. | `number` | `null` | no |
| <a name="input_archive_type"></a> [archive\_type](#input\_archive\_type) | Specifies the storage class or archive type to which you want the object to transition. | `string` | `"Glacier"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name to give the newly provisioned Object Storage bucket. | `string` | `"billing-reports"` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | The storage class of the newly provisioned Object Storage bucket. Supported values are 'standard', 'vault', 'cold', 'smart' and `onerate_active`. | `string` | `"standard"` | no |
| <a name="input_cbr_additional_zone_name"></a> [cbr\_additional\_zone\_name](#input\_cbr\_additional\_zone\_name) | Name of the CBR zone that corresponds to the ip address range set in `additional_allowed_cbr_bucket_ip_addresses`. | `string` | `"company-billing-reports-bucket-access"` | no |
| <a name="input_cbr_billing_zone_name"></a> [cbr\_billing\_zone\_name](#input\_cbr\_billing\_zone\_name) | Name of the CBR zone which represents IBM Cloud billing. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis) | `string` | `"ibmcloud-billing-reports-bucket-writer"` | no |
| <a name="input_cbr_cloudability_zone_name"></a> [cbr\_cloudability\_zone\_name](#input\_cbr\_cloudability\_zone\_name) | Name of the CBR zone which represents IBM Cloudability. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis) | `string` | `"cldy-billing-reports-bucket-reader"` | no |
| <a name="input_cbr_cos_zone_name"></a> [cbr\_cos\_zone\_name](#input\_cbr\_cos\_zone\_name) | Name of the CBR zone which represents Cloud Object Storage service. See [What are CBRs?](https://cloud.ibm.com/docs/account?topic=account-context-restrictions-whatis) | `string` | `"cldy-billing-reports-object-storage"` | no |
| <a name="input_cbr_enforcement_mode"></a> [cbr\_enforcement\_mode](#input\_cbr\_enforcement\_mode) | The rule enforcement mode: * enabled - The restrictions are enforced and reported. This is the default. * disabled - The restrictions are disabled. Nothing is enforced or reported. * report - The restrictions are evaluated and reported, but not enforced. | `string` | `"enabled"` | no |
| <a name="input_cbr_schematics_zone_name"></a> [cbr\_schematics\_zone\_name](#input\_cbr\_schematics\_zone\_name) | Name of the CBR zone which represents Schematics. The schematics zone allows Projects to access and manage the Object Storage bucket. | `string` | `"schematics-billing-reports-bucket-management"` | no |
| <a name="input_cloudability_api_key"></a> [cloudability\_api\_key](#input\_cloudability\_api\_key) | Cloudability API Key. Retrieve your Api Key from https://app.apptio.com/cloudability#/settings/preferences under the section **Cloudability API** select **Enable API** which will generate an api key. Setting this value to __NULL__ will skip adding the IBM Cloud account to Cloudability and only configure IBM Cloud so that the IBM Cloud Account can be added to Cloudability manually | `string` | `null` | no |
| <a name="input_cloudability_auth_type"></a> [cloudability\_auth\_type](#input\_cloudability\_auth\_type) | Select Cloudability authentication mode. Options are:<br/><br/>* `none`: no connection to Cloudability<br/>* `manual`: manually enter in the credentials in the Cloudability UI<br/>* `api_key`: use Cloudability API Keys<br/>* `frontdoor`: Frontdoor Access Administration | `string` | `"api_key"` | no |
| <a name="input_cloudability_environment_id"></a> [cloudability\_environment\_id](#input\_cloudability\_environment\_id) | An ID corresponding to your FrontDoor environment. Required if `cloudability_auth_type` = `frontdoor` | `string` | `null` | no |
| <a name="input_cloudability_host"></a> [cloudability\_host](#input\_cloudability\_host) | IBM Cloudability host name as described in https://help.apptio.com/en-us/cloudability/api/v3/getting%20started%20with%20the%20cloudability.htm | `string` | `"api.cloudability.com"` | no |
| <a name="input_cloudability_iam_custom_role_name"></a> [cloudability\_iam\_custom\_role\_name](#input\_cloudability\_iam\_custom\_role\_name) | Name of the custom role which grants access to the Cloudability service id to read the billing reports from the object storage bucket | `string` | `"CloudabilityStorageCustomRole"` | no |
| <a name="input_cloudability_iam_enterprise_custom_role_name"></a> [cloudability\_iam\_enterprise\_custom\_role\_name](#input\_cloudability\_iam\_enterprise\_custom\_role\_name) | Name of the custom role which grants access to the Cloudability service ID to read the enterprise information. Only used if `is_enterprise_account` is `true`. | `string` | `"CloudabilityListAccCustomRole"` | no |
| <a name="input_cos_folder"></a> [cos\_folder](#input\_cos\_folder) | Folder in the Object Storage bucket to store the account data | `string` | `"IBMCloud-Billing-Reports"` | no |
| <a name="input_cos_instance_name"></a> [cos\_instance\_name](#input\_cos\_instance\_name) | The name to give the Cloud Object Storage instance that will be provisioned by this module. Only required if 'create\_cos\_instance' is true. | `string` | `"billing-report-exports"` | no |
| <a name="input_cos_plan"></a> [cos\_plan](#input\_cos\_plan) | Plan to be used for creating Cloud Object Storage instance. Only used if 'create\_cos\_instance' is true. | `string` | `"cos-one-rate-plan"` | no |
| <a name="input_cross_region_location"></a> [cross\_region\_location](#input\_cross\_region\_location) | Specify the cross-regional bucket location. Supported values are 'us', 'eu', and 'ap'. If you pass a value for this, ensure to set the value of var.region to null. | `string` | `null` | no |
| <a name="input_enable_billing_exports"></a> [enable\_billing\_exports](#input\_enable\_billing\_exports) | Whether billing exports should be enabled | `bool` | `true` | no |
| <a name="input_enable_cloudability_access"></a> [enable\_cloudability\_access](#input\_enable\_cloudability\_access) | Whether to grant cloudability access to read the billing reports | `bool` | `true` | no |
| <a name="input_enterprise_id"></a> [enterprise\_id](#input\_enterprise\_id) | The ID of the enterprise. If `__NULL__` then it is automatically retrieved if `is_enterprise_account` is `true`. Providing this value reduces the access policies that are required to run the DA. | `string` | `null` | no |
| <a name="input_existing_allowed_cbr_bucket_zone_id"></a> [existing\_allowed\_cbr\_bucket\_zone\_id](#input\_existing\_allowed\_cbr\_bucket\_zone\_id) | An extra CBR zone ID which is permitted to access the bucket.  This zone typically represents the ip addresses for your company or workstation to allow access to view the contents of the bucket. It can be used as an alternative to `additional_allowed_cbr_bucket_ip_addresses` in the case that a zone exists. | `string` | `null` | no |
| <a name="input_existing_cos_instance_id"></a> [existing\_cos\_instance\_id](#input\_existing\_cos\_instance\_id) | The ID of an existing Cloud Object Storage instance. Required if 'var.create\_cos\_instance' is false. | `string` | `null` | no |
| <a name="input_existing_kms_instance_crn"></a> [existing\_kms\_instance\_crn](#input\_existing\_kms\_instance\_crn) | The CRN of an existing Key Protect or Hyper Protect Crypto Services instance. Required if 'create\_key\_protect\_instance' is false. | `string` | `null` | no |
| <a name="input_expire_days"></a> [expire\_days](#input\_expire\_days) | Specifies the number of days when the expire rule action takes effect. | `number` | `3` | no |
| <a name="input_frontdoor_public_key"></a> [frontdoor\_public\_key](#input\_frontdoor\_public\_key) | The public key that is used along with the `frontdoor_secret_key` to authenticate requests to Cloudability. Only required if `cloudability_auth_type` is `frontdoor`. See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials. | `string` | `null` | no |
| <a name="input_frontdoor_secret_key"></a> [frontdoor\_secret\_key](#input\_frontdoor\_secret\_key) | The secret key that is used along with the `frontdoor_public_key` to authenticate requests to Cloudability. Only required if `cloudability_auth_type` is `frontdoor`.  See [acquiring an Access Administration API key](/docs/track-spend-with-cloudability?topic=track-spend-with-cloudability-planning#frontdoor-api-key) for steps to create your credentials. | `string` | `null` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud API key corresponding to the cloud account that will be added to Cloudability. For enterprise accounts this should be the primary enterprise account | `string` | n/a | yes |
| <a name="input_is_enterprise_account"></a> [is\_enterprise\_account](#input\_is\_enterprise\_account) | Whether the account corresponding to the `ibmcloud_api_key` is an enterprise account and, if so, is the primary account within the enterprise | `bool` | `false` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the Object Storage bucket encryption key | `string` | `null` | no |
| <a name="input_key_protect_allowed_network"></a> [key\_protect\_allowed\_network](#input\_key\_protect\_allowed\_network) | The type of the allowed network to be set for the Key Protect instance. Possible values are 'private-only', or 'public-and-private'. Only used if 'create\_key\_protect\_instance' is true. | `string` | `"public-and-private"` | no |
| <a name="input_key_protect_instance_name"></a> [key\_protect\_instance\_name](#input\_key\_protect\_instance\_name) | Key Protect instance name | `string` | `"cloudability-bucket-encryption"` | no |
| <a name="input_key_ring_name"></a> [key\_ring\_name](#input\_key\_ring\_name) | Name of the key ring to group keys | `string` | `"bucket-encryption"` | no |
| <a name="input_kms_endpoint_type"></a> [kms\_endpoint\_type](#input\_kms\_endpoint\_type) | The type of endpoint to be used for management of key protect. | `string` | `"public"` | no |
| <a name="input_kms_rotation_enabled"></a> [kms\_rotation\_enabled](#input\_kms\_rotation\_enabled) | If set to true, Key Protect enables a rotation policy on the Key Protect instance. Only used if 'create\_key\_protect\_instance' is true. | `bool` | `true` | no |
| <a name="input_kms_rotation_interval_month"></a> [kms\_rotation\_interval\_month](#input\_kms\_rotation\_interval\_month) | Specifies the number of months for the encryption key to be rotated.. Must be between 1 and 12 inclusive. | `number` | `1` | no |
| <a name="input_management_endpoint_type_for_bucket"></a> [management\_endpoint\_type\_for\_bucket](#input\_management\_endpoint\_type\_for\_bucket) | The type of endpoint for the IBM terraform provider to use to manage the bucket. (public, private, or direct) | `string` | `"public"` | no |
| <a name="input_monitoring_crn"></a> [monitoring\_crn](#input\_monitoring\_crn) | The CRN of an IBM Cloud Monitoring instance to send Object Storage bucket metrics to. If no value passed, metrics are sent to the instance associated to the container's location unless otherwise specified in the Metrics Router service configuration. | `string` | `null` | no |
| <a name="input_object_versioning_enabled"></a> [object\_versioning\_enabled](#input\_object\_versioning\_enabled) | Enable [object versioning](/docs/cloud-object-storage?topic=cloud-object-storage-versioning) to keep multiple versions of an object in a bucket. | `bool` | `false` | no |
| <a name="input_overwrite_existing_reports"></a> [overwrite\_existing\_reports](#input\_overwrite\_existing\_reports) | A new version of report is created or the existing report version is overwritten with every update. | `bool` | `true` | no |
| <a name="input_policy_granularity"></a> [policy\_granularity](#input\_policy\_granularity) | Whether access to the Object Storage bucket is controlled at the bucket (resource), cos instance (serviceInstance), or resource-group (resourceGroup). | `string` | `"resource"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where resources are created | `string` | `"us-south"` | no |
| <a name="input_request_metrics_enabled"></a> [request\_metrics\_enabled](#input\_request\_metrics\_enabled) | If set to `true`, all Object Storage bucket request metrics will be sent to the monitoring service. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of a new or existing resource group where resources are created | `string` | `"cloudability-enablement"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Optional list of tags to be added to created resources | `list(string)` | `[]` | no |
| <a name="input_skip_cloudability_billing_policy"></a> [skip\_cloudability\_billing\_policy](#input\_skip\_cloudability\_billing\_policy) | Whether policy which grants cloudability access to view the billing service. This may be true if the policy already exists because it was created by a previous run. | `bool` | `false` | no |
| <a name="input_skip_iam_authorization_policy"></a> [skip\_iam\_authorization\_policy](#input\_skip\_iam\_authorization\_policy) | Set to true to skip the creation of an IAM authorization policy that permits the Object Storage instance created to read the encryption key from the KMS instance in `existing_kms_instance_crn`. WARNING: An authorization policy must exist before an encrypted bucket can be created | `bool` | `false` | no |
| <a name="input_skip_verification"></a> [skip\_verification](#input\_skip\_verification) | Whether to verify that the IBM Cloud account is successfully integrated with Cloudability. This step is not strictly necessary for adding the account to Cloudability. Only applicable when `cloudability_auth_type` is `api_key`. | `bool` | `false` | no |
| <a name="input_usage_metrics_enabled"></a> [usage\_metrics\_enabled](#input\_usage\_metrics\_enabled) | If set to `true`, all Object Storage bucket usage metrics will be sent to the monitoring service. | `bool` | `true` | no |
| <a name="input_use_existing_iam_custom_role"></a> [use\_existing\_iam\_custom\_role](#input\_use\_existing\_iam\_custom\_role) | Whether the iam\_custom\_roles should be created or if they already exist and they should be linked with a datasource | `bool` | `false` | no |
| <a name="input_use_existing_key_ring"></a> [use\_existing\_key\_ring](#input\_use\_existing\_key\_ring) | Whether the `key_ring_name` corresponds to an existing key ring or a new key ring for storing the encryption key | `string` | `false` | no |
| <a name="input_use_existing_resource_group"></a> [use\_existing\_resource\_group](#input\_use\_existing\_resource\_group) | Whether `resource_group_name` input represents the name of an existing resource group or a new resource group should be created | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_account_cloudability_custom_role_display_name"></a> [bucket\_account\_cloudability\_custom\_role\_display\_name](#output\_bucket\_account\_cloudability\_custom\_role\_display\_name) | Display name of the custom role that grants cloudability access to read the billing reports from the Object Storage bucket |
| <a name="output_bucket_cbr_rules"></a> [bucket\_cbr\_rules](#output\_bucket\_cbr\_rules) | Object Storage bucket rules |
| <a name="output_bucket_crn"></a> [bucket\_crn](#output\_bucket\_crn) | CRN of the Object Storage bucket where billing reports are written to |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | ID of the Object Storage bucket where billing reports are written to |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | Name of the Object Storage bucket where billing reports are written to |
| <a name="output_bucket_region"></a> [bucket\_region](#output\_bucket\_region) | CRN of the Object Storage bucket where billing reports are written to |
| <a name="output_bucket_storage_class"></a> [bucket\_storage\_class](#output\_bucket\_storage\_class) | Storage class of the Object Storage bucket where billing reports are written to |
| <a name="output_cos_bucket_folder"></a> [cos\_bucket\_folder](#output\_cos\_bucket\_folder) | Folder in the Object Storage bucket to store the account data |
| <a name="output_cos_cbr_rule_ids"></a> [cos\_cbr\_rule\_ids](#output\_cos\_cbr\_rule\_ids) | List of all rule ids |
| <a name="output_cos_instance_guid"></a> [cos\_instance\_guid](#output\_cos\_instance\_guid) | The GUID of the Cloud Object Storage instance where the billing reports bucket is created |
| <a name="output_cos_instance_id"></a> [cos\_instance\_id](#output\_cos\_instance\_id) | The ID of the Cloud Object Storage instance where the billing reports bucket is created |
| <a name="output_cos_instance_name"></a> [cos\_instance\_name](#output\_cos\_instance\_name) | Name of the Cloud Object Storage instance |
| <a name="output_enterprise_account_id"></a> [enterprise\_account\_id](#output\_enterprise\_account\_id) | ID of the IBM Cloud account or, in the case of an enterprise, the ID of the primary account in the enterprise |
| <a name="output_enterprise_cloudability_custom_role_display_name"></a> [enterprise\_cloudability\_custom\_role\_display\_name](#output\_enterprise\_cloudability\_custom\_role\_display\_name) | Display name of the custom role that grants cloudability access to read the enterprise accounts |
| <a name="output_enterprise_id"></a> [enterprise\_id](#output\_enterprise\_id) | id of the enterprise if `is_enterprise_account` is enabled |
| <a name="output_key_protect_guid"></a> [key\_protect\_guid](#output\_key\_protect\_guid) | ID of the Key Protect instance which contains the encryption key for the object storage bucket |
| <a name="output_key_protect_instance_policies"></a> [key\_protect\_instance\_policies](#output\_key\_protect\_instance\_policies) | Instance Polices of the Key Protect instance |
| <a name="output_key_protect_name"></a> [key\_protect\_name](#output\_key\_protect\_name) | Name of the Key Protect instance |
| <a name="output_key_rings"></a> [key\_rings](#output\_key\_rings) | IDs of new Key Rings created by the module |
| <a name="output_keys"></a> [keys](#output\_keys) | IDs of new Keys created by the module |
| <a name="output_kms_crn"></a> [kms\_crn](#output\_kms\_crn) | CRN of the KMS instance when an instance |
| <a name="output_kms_key_crn"></a> [kms\_key\_crn](#output\_kms\_key\_crn) | The CRN of the KMS key used to encrypt the object storage bucket |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | ID of the resource group where all resources are deployed into |
| <a name="output_s3_endpoint_direct"></a> [s3\_endpoint\_direct](#output\_s3\_endpoint\_direct) | Direct endpoint to the Object Storage bucket where billing reports are written to |
| <a name="output_s3_endpoint_private"></a> [s3\_endpoint\_private](#output\_s3\_endpoint\_private) | Private endpoint to the Object Storage bucket where billing reports are written to |
| <a name="output_s3_endpoint_public"></a> [s3\_endpoint\_public](#output\_s3\_endpoint\_public) | Public endpoint to the Object Storage bucket where billing reports are written to |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
