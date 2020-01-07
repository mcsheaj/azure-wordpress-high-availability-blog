# vnet deployment
New-AzureRmResourceGroupDeployment -Name vnet-deployment-prod-westus2 -ResourceGroupName rg-wp-prod-westus2-001 -TemplateUri https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/two-tier-vnet/azuredeploy.json -TemplateParameterUri https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/two-tier-vnet/azuredeploy.parameters.json -Mode Incremental

# jumpbox deployment
New-AzureRmResourceGroupDeployment -Name vmss-deployment-wp-jumpbox-prod-westus2 -ResourceGroupName rg-wp-prod-westus2-001 -TemplateUri https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.json -TemplateParameterUri https://raw.githubusercontent.com/mcsheaj/azure-wordpress-high-availability-blog/master/jumpbox-scale-set/azuredeploy.parameters.json -Mode Incremental

