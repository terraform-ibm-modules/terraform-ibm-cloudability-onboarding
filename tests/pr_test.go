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

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Region:       "us-south",
		TerraformVars: map[string]interface{}{
			"resource_group_name":         resourceGroup,
			"use_existing_resource_group": false,
		},
	})
	return options
}

func TestRunDefaultSolution(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "mod-template", defaultSolutionDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

// func TestRunUpgradeSolution(t *testing.T) {
// 	t.Parallel()

// 	options := setupOptions(t, "mod-template-upg", defaultSolutionDir)

// 	output, err := options.RunTestUpgrade()
// 	if !options.UpgradeTestSkipped {
// 		assert.Nil(t, err, "This should not have errored")
// 		assert.NotNil(t, output, "Expected some output")
// 	}
// }
