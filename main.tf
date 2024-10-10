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
  should_fetch_enterprise = var.is_enterprise_account && var.enterprise_id == null
  enterprise              = local.should_fetch_enterprise ? data.ibm_enterprises.enterprises[0].enterprises[0] : null
  enterprise_id           = local.enterprise != null ? local.enterprise.id : var.enterprise_id
  enterprise_account_id   = data.ibm_iam_account_settings.billing_exports_account.account_id
  cos_bucket_crn          = module.cos_bucket.bucket_crn
  bucket_storage_class    = var.cos_plan == "cos-one-rate-plan" ? "onerate_active" : var.bucket_storage_class
}

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.use_existing_resource_group == false ? var.resource_group_name : null
  existing_resource_group_name = var.use_existing_resource_group == true ? var.resource_group_name : null
}

module "cos_bucket" {
  providers = {
    ibm = ibm
  }
  source                              = "./modules/encrypted_cos_bucket"
  resource_group_id                   = module.resource_group.resource_group_id
  resource_tags                       = var.resource_tags
  region                              = var.region
  create_key_protect_instance         = var.create_key_protect_instance
  key_protect_instance_name           = var.key_protect_instance_name
  key_ring_name                       = var.key_ring_name
  key_name                            = var.key_name
  create_cos_instance                 = var.create_cos_instance
  cos_instance_name                   = var.cos_instance_name
  cos_plan                            = var.cos_plan
  access_tags                         = var.access_tags
  existing_cos_instance_id            = var.existing_cos_instance_id
  cross_region_location               = var.cross_region_location
  bucket_name                         = var.bucket_name
  add_bucket_name_suffix              = var.add_bucket_name_suffix
  bucket_storage_class                = local.bucket_storage_class
  management_endpoint_type_for_bucket = var.management_endpoint_type_for_bucket
  retention_enabled                   = var.retention_enabled
  retention_default                   = var.retention_default
  retention_maximum                   = var.retention_maximum
  retention_minimum                   = var.retention_minimum
  retention_permanent                 = var.retention_permanent
  object_versioning_enabled           = var.object_versioning_enabled
  archive_days                        = var.archive_days
  archive_type                        = var.archive_type
  expire_days                         = var.expire_days
  activity_tracker_crn                = var.activity_tracker_crn
  activity_tracker_read_data_events   = var.activity_tracker_read_data_events
  activity_tracker_write_data_events  = var.activity_tracker_write_data_events
  activity_tracker_management_events  = var.activity_tracker_management_events
  monitoring_crn                      = var.monitoring_crn
  request_metrics_enabled             = var.request_metrics_enabled
  usage_metrics_enabled               = var.usage_metrics_enabled
  existing_kms_instance_guid          = var.existing_kms_instance_guid
  bucket_cbr_rules                    = var.bucket_cbr_rules
  instance_cbr_rules                  = var.instance_cbr_rules
  skip_iam_authorization_policy       = var.skip_iam_authorization_policy
}

module "cloudability_bucket_access" {
  source                        = "./modules/cloudability-bucket-access"
  policy_granularity            = var.policy_granularity
  bucket_crn                    = local.cos_bucket_crn
  use_existing_iam_custom_role  = var.use_existing_iam_custom_role
  cloudability_custom_role_name = var.cloudability_custom_role_name
  resource_group_id             = module.resource_group.resource_group_id
}

module "cloudability_enterprise_access" {
  count = var.enable_billing_exports ? 1 : 0
  # if same account then re-use the access group. Otherwise create a new one
  source                           = "./modules/cloudability-enterprise-access"
  enterprise_id                    = local.enterprise_id
  use_existing_iam_custom_role     = var.use_existing_iam_custom_role
  cloudability_custom_role_name    = var.cloudability_enterprise_custom_role_name
  skip_cloudability_billing_policy = var.skip_cloudability_billing_policy
}

module "billing_exports" {
  count               = var.enable_billing_exports ? 1 : 0
  source              = "./modules/billing-exports"
  billing_account_id  = local.enterprise_account_id
  cos_bucket_crn      = local.cos_bucket_crn
  cos_bucket_location = var.region
  cos_folder          = var.cos_folder
  resource_group_id   = module.resource_group.resource_group_id
}

module "cloudability_onboarding" {
  depends_on = [module.billing_exports, module.cloudability_enterprise_access]
  count      = var.enable_billing_exports && var.cloudability_api_key != null ? 1 : 0
  providers = {
    restapi = restapi.cloudability
  }
  source = "./modules/cloudability-onboarding"
  # needed to execute an ibmcloud cli script to check that billing exports have been writted to the cos bucket
  ibmcloud_api_key    = var.ibmcloud_api_key
  cos_bucket_prefix   = var.cos_folder
  cos_bucket_location = var.region
  cos_bucket_crn      = local.cos_bucket_crn
  enterprise_id       = local.enterprise_id
  skip_verification   = var.skip_verification
  cos_instance_name   = var.cos_instance_name
  cloudability_host   = var.cloudability_host
}
