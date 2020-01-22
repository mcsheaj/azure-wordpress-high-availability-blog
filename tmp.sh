#!/bin/bash -xe

# define storage account name and blob 
stor_account=storwpprodwestus2
blob_container=blob-wp-prod-westus2

# get oauth2 token, and parse access_token and expires_on from it, convert expires_on for signedExpiry
oauth2_token=$(curl -H Metadata:true "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://management.azure.com/" | jq .)
access_token=$(echo ${oauth2_token} | jq -r .access_token)
expires_on=$(echo ${oauth2_token} | jq -r .expires_on)

# https://zxq9.com/archives/795
# https://www.epochconverter.com/ 
signedExpiry=$(date -d@"${expires_on}" --utc +%FT%TZ)

# get instance metadata, and parse subscription id and resource group name from it
export instance_meta=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2019-03-11" | jq .)
export subscriptionId=$(echo ${instance_meta} | jq -r .compute.subscriptionId)
export resourceGroupName=$(echo ${instance_meta} | jq -r .compute.resourceGroupName)

# confirm these values
echo access_token=${access_token}
echo expires_on=${expires_on}
echo signedExpiry=${signedExpiry}
echo subscriptionId=${subscriptionId}
echo resourceGroupName=${resourceGroupName}

# construct the base uri for retrieving the SAS token
uri="https://management.azure.com/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Storage/storageAccounts/${stor_account}/listServiceSas/?api-version=2019-06-01"

# construct the authorization header
auth_header="Authorization: Bearer ${access_token}"

# construct the POST body
ss=
body="{\"canonicalizedResource\":\"/blob/${stor_account}/${blob_container}\",\"signedResource\":\"c\",\"signedPermission\":\"rcw\",\"signedProtocol\":\"https\",\"signedStart\":\"\",\"signedExpiry\":\"${signedExpiry}\"}"

# get the SAS token
curl "${uri}" -X "POST" -d "${body}" -H "${auth_header}" | jq .

# for future use
#tags=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/compute/tagsList?api-version=2019-06-04" | jq .)
#ApplicationName=$(echo ${tags} | jq '.[] | select(.name=="ApplicationName")' | jq -r .value)

az rest --method post --uri "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Network/privateDnsZones/${resourceName}?api-version=2018-09-01"

az rest --method post --uri "https://management.azure.com/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.PolicyInsights/policyStates/latest/queryResults?api-version=2018-04-04&$filter=policyAssignmentId eq '/providers/Microsoft.Management/managementGroups/{managementGroupName}/providers/Microsoft.Authorization/policyAssignments/3132643538114acc900af638'"

az login --identity
az storage blob list --container-name blob-wp-test-eastus --account-name storwptesteastus | jq --indent 4 .

         {
            "type": "Microsoft.Network/privateDnsZones/A",
            "apiVersion": "2018-09-01",
            "name": "[concat(variables('privateDnsName'), '/', parameters('storageAccountName'))]",
            "location": "global",
            "dependsOn": [
                "[variables('privateDnsName')]",
                "[variables('publicSubnetEndpointName')]",
                "[variables('privateSubnetEndpointName')]"
            ],
            "properties": {
                "aRecords": [
                    {
                        "ipv4Address": "[reference(variables('publicSubnetEndpointName'), '2019-04-01', 'Full').networkInterfaces[0].ipConfigurations[0].properties.privateIPAddress]"
                    },
                    {
                        "ipv4Address": "[reference(variables('privateSubnetEndpointName'), '2019-04-01', 'Full').networkInterfaces[0].ipConfigurations[0].properties.privateIPAddress]"
                    }
                ],
                "ttl": 3600
            }
        }


az resource show --resource-group rg-wp-test-eastus-001 --resource-type Microsoft.Compute/virtualMachineScaleSets --name vmss-apache-wp-test-eastus | jq --indent 4 .identity
az resource show --resource-group rg-wp-test-eastus-001 --resource-type Microsoft.Compute/virtualMachineScaleSets --name vmss-jumpbox-wp-test-eastus | jq --indent 4 .identity
az role definition list --subscription 1e25beac-0bd5-4dbe-a039-755b538c7938 --name Contributor



# https://negatblog.wordpress.com/2018/06/21/scale-sets-and-load-balancers/
# create a resource group to hold our resources
$ az group create -n appgwrg -l westus
 
# create a scale set with an app gateway; by default, this includes an http
# rule on port 80; we give the public IP address name 'pip' so we can
# refer to it later without having to look up the name of the
# IP address later
$ az vmss create -g appgwrg -n scaleset --app-gateway appgw --image UbuntuLTS --generate-ssh-keys --upgrade-policy-mode Automatic --disable-overprovision --public-ip-address pip-app-gw
 
# to test the load balancing rule on port 80, let's install a web server on
# our scale set VMs using a custom script extension:
$ az vmss extension set -g appgwrg --vmss-name scaleset --publisher "Microsoft.Azure.Extensions" --name "CustomScript" --settings "{\"commandToExecute\": \"apt-get install apache2 -y\"}"
 
# we need to know the public IP address, which we can get with the
# 'az network public-ip show' command
$ az network public-ip show -g appgwrg -n pip
#{
#...
# "ipAddress": "{public-ip-address}",...
#}


# now that we have the public IP address, we can do an http request to
# verify that we get a response back from the web server:
$ curl {public-ip-address}
#<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transit

