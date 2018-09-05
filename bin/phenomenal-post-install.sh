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
  # Checking if extra services have been enable or not. If so, then returning url
  galaxy_include=$(jq -r '.galaxy_include' <<<"$kn_config")
  luigi_include=$(jq -r '.luigi_include' <<<"$kn_config")
  jupyter_include=$(jq -r '.jupyter_include' <<<"$kn_config")
  dashboard_include=$(jq -r '.dashboard_include' <<<"$kn_config")
  logmon_include=$(jq -r '.logmon_include' <<<"$kn_config")
  datafederation_include=$(jq -r '.datafederation_include' <<<"$kn_config")
  
  if [[ "$galaxy_include" == true ]]; then
    echo "http://galaxy.$domain"
  fi  
  if [[ "$luigi_include" == true ]]; then
    echo "http://luigi.$domain"
  fi 
  if [[ "$jupyter_include" == true ]]; then
    echo "http://notebook.$domain"
  fi    
  if [[ "$dashboard_include" == true ]]; then
    echo "http://dashboard.$domain"
  fi
  if [[ "$logmon_include" == true ]]; then
    echo -e "\nLogging and Monitoring Tools:\n"
    echo "http://kibana.$domain"
    echo "http://prometheus.$domain"
    echo "http://grafana.$domain"
  fi
  if [[ "$datafederation_include" == true ]]; then
    echo -e "\nData Federation Tool:\n"
    echo "http://owncloud.$domain"
  fi
fi

# End output
echo
echo 'And if you want to ssh into master, use:'
echo "kn ssh"
