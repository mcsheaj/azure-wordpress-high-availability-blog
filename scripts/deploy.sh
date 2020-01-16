#!/bin/bash -xe

# download the template and parameter files for the VNet with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.parameters.json"

# download the template and parameter files for the JumpBox with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.parameters.json"

# download the temporary gist template and parameter files with no caching
wget -O "azuredeploy.json" --no-cache "https://gist.githubusercontent.com/mcsheaj/37e2e79e0cf4f5ae79e9ccb273854852/raw/5ed563ea59eda73ca37503800506ec7c9b50f5b5/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://gist.githubusercontent.com/mcsheaj/d4369e0c8915c450f8d1caafad487670/raw/b3a31e8913b21424614e76be2345e64865fe4ad8/azuredeploy.parameters.json"

# deploy the VNet
az group deployment create --name "vnet-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "vnet-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy the JumpBox
az group deployment create --name "vmss-deployment-jumpbox-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "vmss-deployment-jumpbox-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy storage
az group deployment create --name "stor-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy endpoints
az group deployment create --name "ep-stor-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy dns
az group deployment create --name "dns-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
