#!/bin/bash

# Exit if a command exits with a non-zero status
set -e

# Get domain from inventory
domain=$(grep "domain" "inventory" |
  cut -d "=" -f 2- |
  awk -F\" '{print $(NF-1)}')

# Read config file into variable as as json
kn_config=$(json2hcl -reverse <config.tfvars)

# Read variables from json-config
proxied=$(jq -r '.cloudflare_proxied' <<<"$kn_config")

# Start writing output
echo
echo 'Services should be reachable at following url:'

# Write alternate url's depending on if cloudflare is proxied or not
if [[ "$proxied" == true ]]; then
  # Create a records variable where the elements in the array "cloudflare_record_texts"
  # ends up on separate lines that can be used in the bash for-loop
  records=$(echo "$kn_config" | jq -r --compact-output '.cloudflare_record_texts[]')
  for record in $records; do
    echo "https://$record.$domain"
  done
else
  echo "http://galaxy.$domain"
  echo "http://notebook.$domain"
  echo "http://luigi.$domain"
  echo "http://dashboard.$domain"
fi

# End output
echo
echo 'And if you want to ssh into master, use:'
echo "kn ssh"


