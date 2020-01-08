#!/bin/bash -xe

# download the template and parameter files for the VNet with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.parameters.json"

# download the template and parameter files for the JumpBox with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.parameters.json"

# download the temporary gist template and parameter files with no caching
wget -O "azuredeploy.json" --no-cache "https://gist.githubusercontent.com/mcsheaj/37e2e79e0cf4f5ae79e9ccb273854852/raw/6accc0031789d335f4efa0e6ee9f4de02aa6da05/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://gist.githubusercontent.com/mcsheaj/d4369e0c8915c450f8d1caafad487670/raw/4d2694262aaab504560b624e39ce9003c880dd58/azuredeploy.parameters.json"

# deploy the VNet
az group deployment create --name "vnet-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy the JumpBox
az group deployment create --name "vmss-deployment-jumpbox-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
