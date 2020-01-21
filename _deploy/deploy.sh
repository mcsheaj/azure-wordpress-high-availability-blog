#!/bin/bash -xe

# download the template and parameter files for the VNet with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vnet-twotier/azuredeploy.parameters.json"

# download the template and parameter files for the Storage and Privatelink with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/stor-privatelink/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/stor-privatelink/azuredeploy.parameters.json"

# download the template and parameter files for the Privatelink DNS address records with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/dns-arecords/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/dns-arecords/azuredeploy.parameters.json"

# download the template and parameter files for the JumpBox scale set with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vmss-jumpbox/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vmss-jumpbox/azuredeploy.parameters.json"

# download the template and parameter files for the Apache scale set with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vmss-apache-agw/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/vmss-apache-agw/azuredeploy.parameters.json"

# download the template and parameter files for the MariaDB instance with no caching
wget -O "azuredeploy.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/sql-mariadb/azuredeploy.json"
wget -O "azuredeploy.parameters.json" --no-cache "https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/sql-mariadb/azuredeploy.parameters.json"

# deploy the VNet
az group deployment create --name "vnet-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "vnet-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy Storage and PrivateLink endpoints and private DNS zone for PrivateLink
az group deployment create --name "ep-stor-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "ep-stor-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy DNS address records for the PrivateLink endpoings
az group deployment create --name "dns-arecords-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json"

# deploy the JumpBox scale set
az group deployment create --name "vmss-jumpbox-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "vmss-jumpbox-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy the Apache scale set
az group deployment create --name "vmss-apache-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "vmss-apache-deployment-apache-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format

# deploy the MariaDB instance
az group deployment create --name "sql-mariadb-deployment-wp-prod-westus2" --resource-group "rg-wp-prod-westus2-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
az group deployment create --name "sql-mariadb-deployment-wp-test-eastus" --resource-group "rg-wp-test-eastus-001" --template-file "azuredeploy.json" --parameters @"azuredeploy.parameters.json" --handle-extended-json-format
