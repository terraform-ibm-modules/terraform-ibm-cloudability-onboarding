<!-- Update the title -->
# Resource instance by id module

<!-- Add a description of module(s) in this repo -->
This module is a meant to supplement the IBM Cloud terraform provider as a data source for requesting the resource information by the id. There is a [`ibm_resource_instance`](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_instance) which accepts the name of the resource but sometimes (such as the case when only given a crn) you don't know the name but you know the id and the name is what you are trying to retrieve.

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
module "cos_instance" {
    source              = "git::https://github.com/terraform-ibm-modules/terraform-ibm-apptio-cloudability-onboarding//modules/data-resource-instance-by-id"
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
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.4.1, < 4.0.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.59.0, < 2.0.0 |

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
