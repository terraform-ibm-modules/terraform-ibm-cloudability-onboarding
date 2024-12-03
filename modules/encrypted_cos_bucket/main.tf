
########################################################################################################################
# Key Protect
########################################################################################################################


locals {
  # variable validation around resource_group_id
  rg_validate_condition = var.create_key_protect_instance && var.resource_group_id == null
  rg_validate_msg       = "A value must be passed for 'resource_group_id' when 'create_key_protect_instance' is true"
  # tflint-ignore: terraform_unused_declarations
  rg_validate_check = regex("^${local.rg_validate_msg}$", (!local.rg_validate_condition ? local.rg_validate_msg : ""))

  # variable validation around new instance vs existing
  key_management_enabled = var.create_key_protect_instance && var.existing_kms_instance_crn != null
  instance_validate_msg  = "'create_key_protect_instance' cannot be true when passing a value for 'existing_kms_instance_crn'"
  # tflint-ignore: terraform_unused_declarations
  instance_validate_check = regex("^${local.instance_validate_msg}$", (!local.key_management_enabled ? local.instance_validate_msg : ""))

  # variable validation when not creating new instance
  existing_instance_validate_condition = !var.create_key_protect_instance && var.existing_kms_instance_crn == null
  existing_instance_validate_msg       = "A value must be provided for 'existing_kms_instance_crn' when 'create_key_protect_instance' is false"
  # tflint-ignore: terraform_unused_declarations
  existing_instance_validate_check = regex("^${local.existing_instance_validate_msg}$", (!local.existing_instance_validate_condition ? local.existing_instance_validate_msg : ""))

  key_ring_name               = var.key_ring_name
  key_name                    = var.key_name == null ? var.bucket_name : var.key_name
  key_id                      = "${var.use_existing_key_ring ? "existing-key-ring" : local.key_ring_name}.${local.key_name}"
  existing_kms_instance_parts = var.existing_kms_instance_crn != null ? split(":", var.existing_kms_instance_crn) : []
  existing_kms_instance_guid  = local.key_management_enabled ? module.key_protect_all_inclusive.kms_guid : local.existing_kms_instance_parts[7]
  existing_kms_instance_crn   = local.key_management_enabled ? module.key_protect_all_inclusive.key_protect_crn : var.existing_kms_instance_crn
}

# create the key protect instance to encrypt the Object Storage bucket
module "key_protect_all_inclusive" {
  providers = {
    ibm = ibm
  }
  source                      = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                     = "4.17.0"
  create_key_protect_instance = var.create_key_protect_instance
  key_protect_instance_name   = var.key_protect_instance_name
  resource_group_id           = var.resource_group_id
  enable_metrics              = true
  existing_kms_instance_crn   = var.existing_kms_instance_crn
  key_endpoint_type           = var.key_endpoint_type
  rotation_enabled            = var.rotation_enabled
  rotation_interval_month     = var.rotation_interval_month
  key_ring_endpoint_type      = var.key_ring_endpoint_type
  key_protect_allowed_network = var.key_protect_allowed_network
  region                      = var.region
  keys = [{
    key_ring_name     = local.key_ring_name
    existing_key_ring = var.use_existing_key_ring
    keys = [
      {
        key_name                = local.key_name
        rotation_interval_month = var.rotation_interval_month
      }
    ]
  }]
  resource_tags = var.resource_tags
  access_tags   = var.access_tags
}

##############################################################################
# Get Cloud Account ID
##############################################################################

# Create COS instance and Key Protect instance.
# Create Object Storage bucket-1 with:
# - Encryption
# - Monitoring
# - Activity Tracking

########################################################################################################################
# COS
########################################################################################################################

locals {
  bucket_storage_class = var.cos_plan == "cos-one-rate-plan" ? "onerate_active" : var.bucket_storage_class
  kms_key_crn          = module.key_protect_all_inclusive.keys[local.key_id].crn
}
module "cos_bucket" {
  providers = {
    ibm = ibm
  }
  source                              = "terraform-ibm-modules/cos/ibm"
  version                             = "8.15.2"
  bucket_name                         = var.bucket_name
  add_bucket_name_suffix              = var.add_bucket_name_suffix
  management_endpoint_type_for_bucket = var.management_endpoint_type_for_bucket
  cos_tags                            = var.resource_tags
  resource_group_id                   = var.resource_group_id
  cos_instance_name                   = var.cos_instance_name
  cos_plan                            = var.cos_plan
  bucket_storage_class                = local.bucket_storage_class
  region                              = var.region
  cross_region_location               = var.cross_region_location
  access_tags                         = var.access_tags
  archive_days                        = var.archive_days
  archive_type                        = var.archive_type
  monitoring_crn                      = var.monitoring_crn
  activity_tracker_read_data_events   = var.activity_tracker_read_data_events
  activity_tracker_write_data_events  = var.activity_tracker_write_data_events
  activity_tracker_management_events  = var.activity_tracker_management_events
  request_metrics_enabled             = var.request_metrics_enabled
  usage_metrics_enabled               = var.usage_metrics_enabled
  create_cos_instance                 = var.create_cos_instance
  existing_cos_instance_id            = var.existing_cos_instance_id
  skip_iam_authorization_policy       = var.skip_iam_authorization_policy # Required since cos_bucket1 creates the IAM authorization policy
  retention_enabled                   = var.retention_enabled             # disable retention for test environments - enable for stage/prod
  existing_kms_instance_guid          = local.existing_kms_instance_guid
  kms_encryption_enabled              = local.key_management_enabled
  kms_key_crn                         = local.kms_key_crn
  bucket_cbr_rules                    = var.cos_bucket_cbr_rules
  instance_cbr_rules                  = var.cos_instance_cbr_rules
  expire_days                         = var.expire_days
  retention_default                   = var.retention_default
  retention_maximum                   = var.retention_maximum
  retention_minimum                   = var.retention_minimum
  retention_permanent                 = var.retention_permanent
  object_versioning_enabled           = var.object_versioning_enabled
}
