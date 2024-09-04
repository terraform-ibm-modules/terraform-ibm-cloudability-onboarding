##############################################################################
# Default example
##############################################################################

module "cloudability_onboarding" {
  source                     = "../../"
  cos_folder                 = "${var.prefix}-Reports"
  skip_verification          = true
  enable_cloudability_access = true
  ibmcloud_api_key           = var.ibmcloud_api_key
  cloudability_api_key       = null
  is_enterprise_account      = false
  create_resource_group      = true
  resource_group_name        = var.resource_group
  resource_tags              = var.resource_tags
  access_tags                = var.access_tags
  # region needs to provide cross region support.
  region                              = var.region
  create_key_protect_instance         = true
  key_protect_instance_name           = "${var.prefix}-KP-Cloudability"
  key_ring_name                       = "${var.prefix}keyring"
  key_name                            = "${var.prefix}key"
  create_cos_instance                 = true
  cos_instance_name                   = "${var.prefix}-COS-Cloudability"
  bucket_name                         = var.prefix
  add_bucket_name_suffix              = true
  management_endpoint_type_for_bucket = "public"
  retention_enabled                   = false
  object_versioning_enabled           = false
}
