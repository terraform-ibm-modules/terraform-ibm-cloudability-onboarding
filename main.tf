data "ibm_iam_account_settings" "billing_exports_account" {
}

data "ibm_enterprises" "enterprises" {
  count = local.should_fetch_enterprise ? 1 : 0
  lifecycle {
    postcondition {
      condition     = contains(self.enterprises[*].enterprise_account_id, data.ibm_iam_account_settings.billing_exports_account.account_id)
      error_message = "Enterprise Onboarding should enable exports at the root account but `ibm_cloud_apikey` is not for the root enterprise account."
    }
  }
}
locals {
  should_fetch_enterprise     = var.is_enterprise_account && var.enterprise_id == null
  enterprise                  = local.should_fetch_enterprise ? data.ibm_enterprises.enterprises[0].enterprises[0] : null
  enterprise_id               = local.enterprise != null ? local.enterprise.id : var.enterprise_id
  enterprise_account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  cos_bucket_crn              = module.cos_bucket.bucket_crn
  bucket_storage_class        = var.cos_plan == "cos-one-rate-plan" ? "onerate_active" : var.bucket_storage_class
  create_key_protect_instance = var.existing_kms_instance_crn == null
  create_cos_instance         = var.existing_cos_instance_id == null
  additional_zone_addresses   = [for ip_addresses in var.additional_allowed_cbr_bucket_ip_addresses : length(regexall("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip_addresses)) > 0 ? { type = "ipAddress", value = ip_addresses } : { type = "ipRange", value = ip_addresses }]
}

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.2.1"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.use_existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.use_existing_resource_group == true ? var.resource_group_name : null
}

##############################################################################
# Create CBR Zone
##############################################################################

module "cbr_zone_ibmcloud_billing" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = var.cbr_billing_zone_name
  zone_description = "IBM Cloud Billing report exports to object storage. Managed by IBM Cloudability Enablement deployable architecture"
  account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  addresses = [
    {
      type = "serviceRef", # to bind a schematics to the zone
      ref = {
        # Allow all schematics instances from all geographies
        account_id   = data.ibm_iam_account_settings.billing_exports_account.account_id
        service_name = "billing"
      }
    }
  ]
}

module "cbr_zone_cloudability" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = var.cbr_cloudability_zone_name
  zone_description = "IBM Cloudability access to billing reports object storage bucket. Managed by IBM Cloudability Enablement deployable architecture"
  account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  addresses = [
    {
      type = "serviceRef",
      ref = {
        # Allow all schematics instances from all geographies
        account_id   = data.ibm_iam_account_settings.billing_exports_account.account_id
        service_name = "cloudability"
      }
    }
  ]
}


module "cbr_zone_additional" {
  count            = length(local.additional_zone_addresses) > 0 ? 1 : 0
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = var.cbr_additional_zone_name
  zone_description = "Additional IP Addresses allowed to access the billing reports bucket. Managed by IBM Cloudability Enablement deployable architecture"
  account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  addresses        = local.additional_zone_addresses
}

module "cbr_zone_schematics" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = var.cbr_schematics_zone_name
  zone_description = "Schematics access to manage the Object storage bucket through Projects. Managed by IBM Cloudability Enablement deployable architecture"
  account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  addresses = [{
    type = "serviceRef", # to bind a schematics to the zone
    ref = {
      # Allow all schematics instances from all geographies
      account_id   = data.ibm_iam_account_settings.billing_exports_account.account_id
      service_name = "schematics"
    }
  }]
}

module "cbr_zone_cos" {
  source           = "terraform-ibm-modules/cbr/ibm//modules/cbr-zone-module"
  version          = "1.29.0"
  name             = var.cbr_cos_zone_name
  zone_description = "Cloud Object storage can access the encryption key to manage the Object storage bucket. Managed by IBM Cloudability Enablement deployable architecture"
  account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
  addresses = [{
    type = "serviceRef", # to bind a schematics to the zone
    ref = {
      # Allow cloud-object-storage instances from all geographies
      account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
      service_name     = "cloud-object-storage"
      service_instance = module.cos_bucket.cos_instance_guid
    }
  }]
}

locals {
  cos_instance_rule_contexts = [{
    attributes = [
      {
        name  = "endpointType"
        value = "public"
      },
      {
        name  = "networkZoneId"
        value = module.cbr_zone_cloudability.zone_id
      }
    ]
    },
    {
      attributes = [
        {
          name  = "networkZoneId"
          value = module.cbr_zone_schematics.zone_id
        }
      ]
    },
    {
      attributes = [
        {
          name  = "networkZoneId"
          value = module.cbr_zone_ibmcloud_billing.zone_id
        }
      ]
    }
  ]
  kms_key_rule_contexts = [{
    attributes = [
      {
        name  = "networkZoneId"
        value = module.cbr_zone_cos.zone_id
      }
    ]
    },
    {
      attributes = [
        {
          name  = "endpointType"
          value = var.management_endpoint_type_for_bucket
        },
        {
          name  = "networkZoneId"
          value = module.cbr_zone_schematics.zone_id
        }
      ]
    }
  ]
  additional_rule_contexts            = length(local.additional_zone_addresses) > 0 ? [{ attributes = [{ name = "networkZoneId", value = module.cbr_zone_additional[0].zone_id }] }] : []
  existing_allowed_cbr_bucket_zone_id = var.existing_allowed_cbr_bucket_zone_id != null ? [{ attributes = [{ name = "networkZoneId", value = var.existing_allowed_cbr_bucket_zone_id }] }] : []
  all_rule_contexts                   = concat(local.cos_instance_rule_contexts, local.additional_rule_contexts, local.existing_allowed_cbr_bucket_zone_id)

  cos_bucket_cbr_rules = [
    {
      description      = "Access to the billing report exports bucket is limited to IBM Cloudability and IBM Cloud Billing. Managed by IBM Cloudability Enablement deployable architecture."
      enforcement_mode = var.cbr_enforcement_mode
      account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
      rule_contexts    = local.all_rule_contexts
    }
  ]
  all_kms_rule_contexts = concat(local.kms_key_rule_contexts, local.additional_rule_contexts, local.existing_allowed_cbr_bucket_zone_id)
  kms_key_cbr_rules = [
    {
      description      = "Access to the kms encryption key is limited to being accessed by cloud object storage. Managed by IBM Cloudability Enablement deployable architecture."
      enforcement_mode = var.cbr_enforcement_mode
      account_id       = data.ibm_iam_account_settings.billing_exports_account.account_id
      rule_contexts    = local.all_kms_rule_contexts
    }
  ]
}

module "cos_bucket" {
  providers = {
    ibm = ibm
  }
  source                              = "./modules/encrypted_cos_bucket"
  resource_group_id                   = module.resource_group.resource_group_id
  resource_tags                       = var.resource_tags
  region                              = var.region
  create_key_protect_instance         = local.create_key_protect_instance
  key_protect_instance_name           = var.key_protect_instance_name
  key_ring_name                       = var.key_ring_name
  key_name                            = var.key_name
  create_cos_instance                 = local.create_cos_instance
  cos_instance_name                   = var.cos_instance_name
  cos_plan                            = var.cos_plan
  access_tags                         = var.access_tags
  existing_cos_instance_id            = var.existing_cos_instance_id
  cross_region_location               = var.cross_region_location
  bucket_name                         = var.bucket_name
  add_bucket_name_suffix              = var.add_bucket_name_suffix
  bucket_storage_class                = local.bucket_storage_class
  management_endpoint_type_for_bucket = var.management_endpoint_type_for_bucket
  retention_enabled                   = false
  object_versioning_enabled           = var.object_versioning_enabled
  archive_days                        = var.archive_days
  archive_type                        = var.archive_type
  expire_days                         = var.expire_days
  activity_tracker_read_data_events   = var.activity_tracker_read_data_events
  activity_tracker_write_data_events  = var.activity_tracker_write_data_events
  activity_tracker_management_events  = var.activity_tracker_management_events
  monitoring_crn                      = var.monitoring_crn
  request_metrics_enabled             = var.request_metrics_enabled
  usage_metrics_enabled               = var.usage_metrics_enabled
  use_existing_key_ring               = var.use_existing_key_ring
  existing_kms_instance_crn           = var.existing_kms_instance_crn
  rotation_interval_month             = var.kms_rotation_interval_month
  rotation_enabled                    = var.kms_rotation_enabled
  key_endpoint_type                   = var.kms_endpoint_type
  key_ring_endpoint_type              = var.kms_endpoint_type
  cos_bucket_cbr_rules                = local.cos_bucket_cbr_rules
  kms_key_cbr_rules                   = local.kms_key_cbr_rules
  skip_iam_authorization_policy       = var.skip_iam_authorization_policy
  key_protect_allowed_network         = var.key_protect_allowed_network
}

# Only executes if cloudability_auth_type is not "none"
module "cloudability_bucket_access" {
  count                             = var.cloudability_auth_type != "none" ? 1 : 0
  source                            = "./modules/cloudability-bucket-access"
  policy_granularity                = var.policy_granularity
  bucket_crn                        = local.cos_bucket_crn
  use_existing_iam_custom_role      = var.use_existing_iam_custom_role
  cloudability_iam_custom_role_name = var.cloudability_iam_custom_role_name
  resource_group_id                 = module.resource_group.resource_group_id
}

moved {
  from = module.cloudability_bucket_access
  to   = module.cloudability_bucket_access[0]
}

# Only executes if cloudability_auth_type is not "none" and it is an enterprise account
module "cloudability_enterprise_access" {
  count = var.cloudability_auth_type != "none" && var.is_enterprise_account ? 1 : 0
  # if same account then re-use the access group. Otherwise create a new one
  source                            = "./modules/cloudability-enterprise-access"
  enterprise_id                     = local.enterprise_id
  use_existing_iam_custom_role      = var.use_existing_iam_custom_role
  cloudability_iam_custom_role_name = var.cloudability_iam_enterprise_custom_role_name
  skip_cloudability_billing_policy  = var.skip_cloudability_billing_policy
}

module "billing_exports" {
  count               = var.enable_billing_exports ? 1 : 0
  source              = "./modules/billing-exports"
  billing_account_id  = local.enterprise_account_id
  cos_bucket_crn      = local.cos_bucket_crn
  cos_bucket_location = var.region
  cos_folder          = var.cos_folder
  resource_group_id   = module.resource_group.resource_group_id
  versioning          = var.overwrite_existing_reports ? "overwrite" : "new"
}

module "cos_instance" {
  count  = var.cos_instance_name == null ? 1 : 0
  source = "./modules/data-resource-instance-by-id"
  guid   = module.cos_bucket.cos_instance_id
}

locals {
  cos_instance_name = var.cos_instance_name == null ? module.cos_instance.name : var.cos_instance_name
}

# Only executes if "api_key", "frontdoor"
module "cloudability_onboarding" {
  depends_on = [module.billing_exports, module.cloudability_enterprise_access]
  count      = contains(["api_key", "frontdoor"], var.cloudability_auth_type) ? 1 : 0
  providers = {
    restapi = restapi.cloudability
  }
  source = "./modules/cloudability-onboarding"
  # needed to execute an ibmcloud cli script to check that billing exports have been writted to the Object Storage bucket
  ibmcloud_api_key    = var.ibmcloud_api_key
  cos_bucket_prefix   = var.cos_folder
  cos_bucket_location = var.region
  cos_bucket_crn      = local.cos_bucket_crn
  enterprise_id       = local.enterprise_id
  skip_verification   = var.cloudability_auth_type != "api_key" || var.skip_verification
  cos_instance_name   = local.cos_instance_name
  cloudability_host   = var.cloudability_host
}
