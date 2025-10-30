#!/bin/bash
set -e

source /home/devuser/experimental/config/cli_versions.sh

echo "🌍 Installing Terraform ${TERRAFORM_VERSION}..."
curl -fsSL -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
unzip -q terraform.zip
sudo mv terraform /usr/local/bin/
rm terraform.zip
terraform -v
