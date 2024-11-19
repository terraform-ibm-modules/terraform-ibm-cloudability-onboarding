#!/bin/bash

set -e

# shellcheck disable=SC2154
api_key="$(echo "$ibmcloud_api_key" | awk '{print $2}')" # pragma: allowlist secret
# shellcheck disable=SC2154
bucket_name="$(echo "$cos_bucket_name" | awk '{print $3}')"
# shellcheck disable=SC2154
bucket_prefix="$(echo "$cos_bucket_prefix" | awk '{print $4}')"
# shellcheck disable=SC2154
region="$(echo "$cos_region" | awk '{print $5}')"

# Quoting $api_key prevents login from working
# shellcheck disable=SC2086
ibmcloud login -a cloud.ibm.com --apikey $api_key
timeout_seconds=1200 # 20 minutes
sleep_seconds=10
number_of_tries=$((timeout_seconds / sleep_seconds))
complete=false
for ((i = 1; i <= number_of_tries; i++)); do
  # Count is used to verify that a file exists in the bucket. It is parsed into a number
  # shellcheck disable=SC2034
  count=$(($(ibmcloud cos objects --bucket "$bucket_name" --prefix "$bucket_prefix" --region "$region" --json | jq -r  ".Contents? | length")+0))
  echo "Waiting for billing reports to exist in Object Storage bucket '$bucket_name'... ($${i}/$${number_of_tries})"
  # shellcheck disable=SC2071
  # shellcheck disable=SC2050
  if [[ count > 0 ]]; then
      complete=true
      break
  fi
  sleep $sleep_seconds
done
if ! $complete; then
  echo "Unable to successfully validate billing exports; Billing reports have not been added to the directory. Please try running this again later."
  exit 1
fi
