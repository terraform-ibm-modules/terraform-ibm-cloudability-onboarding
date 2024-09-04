<!-- Update this title with a descriptive name. Use sentence case. -->
# Apptio Cloudability onboarding Deployable Architecture (DA)

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

This repository contains the necessary modules and deployable architecture (DA) to onboarding an IBM Cloud account or enterprise to Apptio Cloudability.

[All Inclusive](./solutions/all-inclusive)

<!-- The following content is automatically populated by the pre-commit hook -->
<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-apptio-cloudability-onboarding](#terraform-ibm-apptio-cloudability-onboarding)
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


<!-- Leave this section as is so that your module has a link to local development environment set-up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
