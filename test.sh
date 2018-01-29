#!/bin/bash

set -v

KN_BRANCH="feature/phenomenal-kn"
PROVISIONER="andersla/provisioners:phnmnl-plugin-kubenow"

docker build -t "$PROVISIONER" .

curl -f "https://raw.githubusercontent.com/kubenow/KubeNow/$KN_BRANCH/bin/kn" -o "/tmp/kn"
sudo mv /tmp/kn /usr/local/bin/
sudo chmod +x /usr/local/bin/kn

rm -fr test-deployment
/usr/local/bin/kn --preset phenomenal init openstack test-deployment

cd test-deployment

# Common
sed -i -e "s/your-cluster-prefix/phnmnl-plugin-ci-${TRAVIS_BUILD_NUMBER}-${HOST_CLOUD}/g" terraform.tfvars
# AWS
sed -i -e "s/your-acces-key-id/${AWS_ACCESS_KEY_ID}/g" terraform.tfvars
sed -i -e "s#your-secret-access-key#${AWS_SECRET_ACCESS_KEY}#g" terraform.tfvars
sed -i -e "s/eu-west-1/${AWS_DEFAULT_REGION}/g" terraform.tfvars
GCE
printf '%s\n' "$GCE_CREDENTIALS" > "./service-account.json"
sed -i -e "s/your_project_id/${GCE_PROJECT_ID}/g" terraform.tfvars
# AZURE
sed -i -e "s/your-subscription_id/${AZURE_SUBSCRIPTION_ID}/g" terraform.tfvars
sed -i -e "s/your-client_id/${AZURE_CLIENT_ID}/g" terraform.tfvars
sed -i -e "s/your-client_secret/${AZURE_CLIENT_SECRET}/g" terraform.tfvars
sed -i -e "s/your-tenant_id/${AZURE_TENANT_ID}/g" terraform.tfvars
# OS
sed -i -e "s/your-pool-name/${OS_POOL_NAME}/g" terraform.tfvars
sed -i -e "s/external-net-uuid/${OS_EXTERNAL_NET_UUID}/g" terraform.tfvars
sed -i -e "s/your-master-flavor/${OS_MASTER_FLAVOR}/g" terraform.tfvars
sed -i -e "s/your-node-flavor/${OS_NODE_FLAVOR}/g" terraform.tfvars
sed -i -e "s/your-edge-flavor/${OS_EDGE_FLAVOR}/g" terraform.tfvars
sed -i -e "s/your-glusternode-flavor/${OS_NODE_FLAVOR}/g" terraform.tfvars
# Enable edges
sed -i -e "s/# edge/edge/g" terraform.tfvars
# Enable glusternodes
sed -i -e "s/# glusternode/glusternode/g" terraform.tfvars
# Cloudflare
sed -i -e "s/# use_cloudflare/use_cloudflare/g" terraform.tfvars
sed -i -e "s/# cloudflare_email = \"your-cloudflare-email\"/cloudflare_email = \"${CI_CLOUDFLARE_EMAIL}\"/g" terraform.tfvars
sed -i -e "s/# cloudflare_token = \"your-cloudflare-token\"/cloudflare_token = \"${CI_CLOUDFLARE_TOKEN}\"/g" terraform.tfvars
sed -i -e "s/# cloudflare_domain = \"your-domain-name\"/cloudflare_domain = \"${CI_CLOUDFLARE_DOMAIN}\"/g" terraform.tfvars
sed -i -e "s/# cloudflare_subdomain = \"your-subdomain-name\"/cloudflare_subdomain = \"phnmnl-plugin-ci-${TRAVIS_BUILD_NUMBER}-${HOST_CLOUD}\"/g" terraform.tfvars

# kn apply
