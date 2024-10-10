
########################################################################################################################
# Key Protect
########################################################################################################################


locals {
  key_ring_name          = var.key_ring_name
  key_name               = var.key_name == null ? var.bucket_name : var.key_name
  key_management_enabled = var.create_key_protect_instance
  # tflint-ignore: terraform_unused_declarations
  validate_key_protect_variables = local.key_ring_name != null && local.key_name != null
  key_id                         = local.key_management_enabled ? "${local.key_ring_name}.${local.key_name}" : null
  existing_kms_instance_guid     = local.key_management_enabled ? module.key_protect_all_inclusive[0].kms_guid : var.existing_kms_instance_guid
  kms_key_crn                    = local.key_management_enabled ? module.key_protect_all_inclusive[0].keys[local.key_id].crn : null
}

# create the key protect instance to encrypt the cos bucket
module "key_protect_all_inclusive" {
  providers = {
    ibm = ibm
  }
  count                     = var.create_key_protect_instance ? 1 : 0
  source                    = "terraform-ibm-modules/kms-all-inclusive/ibm"
  version                   = "4.15.13"
  key_protect_instance_name = var.key_protect_instance_name
  resource_group_id         = var.resource_group_id
  enable_metrics            = true
  region                    = var.region
  keys = [{
    key_ring_name = local.key_ring_name
    keys = [
      {
        key_name = local.key_name
      }
    ]
  }]
  resource_tags = var.resource_tags
}

##############################################################################
# Get Cloud Account ID
##############################################################################

# Create COS instance and Key Protect instance.
# Create COS bucket-1 with:
# - Encryption
# - Monitoring
# - Activity Tracking

########################################################################################################################
# COS
########################################################################################################################

locals {
  bucket_storage_class = var.cos_plan == "cos-one-rate-plan" ? "onerate_active" : var.bucket_storage_class
}
module "cos_bucket" {
  providers = {
    ibm = ibm
  }
  source                              = "terraform-ibm-modules/cos/ibm"
  version                             = "8.11.14"
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
  activity_tracker_crn                = var.activity_tracker_crn
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
  bucket_cbr_rules                    = var.bucket_cbr_rules
  instance_cbr_rules                  = var.instance_cbr_rules
  expire_days                         = var.expire_days
  retention_default                   = var.retention_default
  retention_maximum                   = var.retention_maximum
  retention_minimum                   = var.retention_minimum
  retention_permanent                 = var.retention_permanent
  object_versioning_enabled           = var.object_versioning_enabled
}
