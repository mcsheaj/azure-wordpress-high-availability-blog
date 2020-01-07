# jumpbox deployment local params file
wget -O azuredeploy.json --no-cache https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/two-tier-vnet/azuredeploy.json
wget -O azuredeploy.parameters.json --no-cache https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/two-tier-vnet/azuredeploy.parameters.json
New-AzureRmResourceGroupDeployment -Name vnet-deployment-wp-prod-westus2 -ResourceGroupName rg-wp-prod-westus2-001 -TemplateFile $HOME/azuredeploy.json -TemplateParameterFile $HOME/azuredeploy.parameters.json -Mode Incremental

# jumpbox deployment local params file
wget -O azuredeploy.json --no-cache https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.json
wget -O azuredeploy.parameters.json --no-cache https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.parameters.json
New-AzureRmResourceGroupDeployment -Name vmss-deployment-jumpbox-wp-prod-westus2 -ResourceGroupName rg-wp-prod-westus2-001 -TemplateFile $HOME/azuredeploy.json -TemplateParameterFile $HOME/azuredeploy.parameters.json -Mode Incremental

