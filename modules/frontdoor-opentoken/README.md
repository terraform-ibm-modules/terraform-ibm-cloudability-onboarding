<!-- Update the title -->
# Frontdoor-frontdoor

This module requests a token for the authentication to Cloudability using the Access Administration apptio-opentoken.

### Usage

<!--
Add an example of the use of the module in the below code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl
module "frontdoor_auth" {
  source = "./modules/frontdoor-opentoken"
  key    = var.frontdoor_public_key
  secret = var.frontdoor_secret_key # pragma: allowlist secret
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

No permissions are needed to run this module.



<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | >= 3.4.1, < 4.0.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [http_http.apikeylogin](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_host"></a> [host](#input\_host) | Frontdoor application host name | `string` | `"https://frontdoor.apptio.com"` | no |
| <a name="input_key"></a> [key](#input\_key) | The api key id from frontdoor | `string` | n/a | yes |
| <a name="input_secret"></a> [secret](#input\_secret) | The api key secret from frontdoor | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_status_code"></a> [status\_code](#output\_status\_code) | The http status code from the authentication request. |
| <a name="output_token"></a> [token](#output\_token) | The unique identifier of the billing\_report\_snapshot. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
