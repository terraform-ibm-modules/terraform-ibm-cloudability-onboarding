// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const defaultSolutionDir = "./"

func setupOptions(t *testing.T, prefix string, dir string, terraformOptions map[string]interface{}) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Region:        "us-south",
		TerraformVars: terraformOptions,
	})
	return options
}

func TestRunDefaultSolution(t *testing.T) {
	// Remove Parallel execution since Billing Exports can only be enabled once on an account at a given time. Running in parallel causes the tests to create a conflict by trying to enable billing reports twice on the account.
	// t.Parallel()

	options := setupOptions(t, "mod-template", defaultSolutionDir, map[string]interface{}{
		"resource_group_name":                 resourceGroup,
		"use_existing_resource_group":         true,
		"use_existing_iam_custom_role":        true,
		"cloudability_iam_custom_role_name":   "CldyStorageDefaultTest",
		"skip_cloudability_billing_policy":    true,
		"enable_billing_exports":              false,
		"cloudability_auth_type":              "manual",
		"management_endpoint_type_for_bucket": "private",
		"cbr_billing_zone_name":               "default-reports-bucket-writer",
		"cbr_cloudability_zone_name":          "default-reports-bucket-reader",
		"cbr_schematics_zone_name":            "default-schematics-bucket-management",
		"cbr_cos_zone_name":                   "default-reports-object-storage",
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestNoneCloudabilityAuthTypeSolution(t *testing.T) {
	// Remove Parallel execution since Billing Exports can only be enabled once on an account at a given time. Running in parallel causes the tests to create a conflict by trying to enable billing reports twice on the account.
	// t.Parallel()

	options := setupOptions(t, "mod-template", defaultSolutionDir, map[string]interface{}{
		"resource_group_name":                 resourceGroup,
		"use_existing_resource_group":         true,
		"use_existing_iam_custom_role":        false,
		"cloudability_iam_custom_role_name":   "CldyStorageDefaultTest",
		"skip_cloudability_billing_policy":    true,
		"enable_billing_exports":              false,
		"cloudability_auth_type":              "none",
		"management_endpoint_type_for_bucket": "private",
		"cbr_billing_zone_name":               "cldy-reports-bucket-writer",
		"cbr_cloudability_zone_name":          "cldy-reports-bucket-reader",
		"cbr_schematics_zone_name":            "cldy-schematics-bucket-management",
		"cbr_cos_zone_name":                   "cldy-reports-object-storage",
	})

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeSolution(t *testing.T) {
	// Remove Parallel execution since Billing Exports can only be enabled once on an account at a given time. Running in parallel causes the tests to create a conflict by trying to enable billing reports twice on the account.
	// t.Parallel()

	options := setupOptions(t, "mod-template-upg", defaultSolutionDir, map[string]interface{}{
		"resource_group_name":                 resourceGroup,
		"use_existing_resource_group":         true,
		"use_existing_iam_custom_role":        true,
		"cloudability_iam_custom_role_name":   "CldyStorageDefaultTest",
		"skip_cloudability_billing_policy":    true,
		"enable_billing_exports":              false,
		"cos_plan":                            "standard",
		"expire_days":                         7,
		"cloudability_auth_type":              "manual",
		"management_endpoint_type_for_bucket": "private",
		// "cbr_billing_zone_name":             "upgrade-reports-bucket-writer",
		// "cbr_cloudability_zone_name":        "upgrade-reports-bucket-reader",
		// "cbr_schematics_zone_name":          "upgrade-schematics-bucket-management",
		// "cbr_cos_zone_name":                 "upgrade-reports-object-storage",
	})

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
