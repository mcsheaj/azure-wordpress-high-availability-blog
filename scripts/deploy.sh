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


{
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSIsImtpZCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2YzOWUxZjc0LTY0M2QtNDNkZC05NDljLTZiNzY0MGMyNTVmZC8iLCJpYXQiOjE1Nzg0NDcxOTcsIm5iZiI6MTU3ODQ0NzE5NywiZXhwIjoxNTc4NDc2Mjk3LCJhaW8iOiI0Mk5nWUdnNTg5cWtvMytLellGdkxrejYrZTA4QUE9PSIsImFwcGlkIjoiMWNjMjM4MjQtNTVjYS00NjM1LTgwNDgtNzZhMmQ4YjY5MTMwIiwiYXBwaWRhY3IiOiIyIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvZjM5ZTFmNzQtNjQzZC00M2RkLTk0OWMtNmI3NjQwYzI1NWZkLyIsIm9pZCI6ImY5M2MyMGM1LWU2NjgtNDcxNC1hMjMzLWY0Nzk0MjA0OWU5MSIsInN1YiI6ImY5M2MyMGM1LWU2NjgtNDcxNC1hMjMzLWY0Nzk0MjA0OWU5MSIsInRpZCI6ImYzOWUxZjc0LTY0M2QtNDNkZC05NDljLTZiNzY0MGMyNTVmZCIsInV0aSI6Ii1JQXJqbHIyR1VtSGdYZF82Q01OQUEiLCJ2ZXIiOiIxLjAiLCJ4bXNfbWlyaWQiOiIvc3Vic2NyaXB0aW9ucy8xZTI1YmVhYy0wYmQ1LTRkYmUtYTAzOS03NTViNTM4Yzc5MzgvcmVzb3VyY2Vncm91cHMvcmctd3AtcHJvZC13ZXN0dXMyLTAwMS9wcm92aWRlcnMvTWljcm9zb2Z0Lk1hbmFnZWRJZGVudGl0eS91c2VyQXNzaWduZWRJZGVudGl0aWVzL3VhaS1iYXN0aW9uLXdwLXByb2Qtd2VzdHVzMiJ9.oUcMFmcW0Si8uzMr8bQIoml08Nv1PX2VpTKskNNiENdOcN_ULNEDcdNLFdKZht28FW4Njxh6Mo_JjydjksULlzGS5DQzzekajjlqLgiohBIiCXCQLLJKhx8X1QjszLqwa5ZqurRe72jMhy1zfoo7cFu7iO3PWOniS_sHfCYf1lLbUgTwkTSVv-5XMP-XLiqbLqf4dKhdC4Vj3t7SY2ynTO8Lz4ZClsDhYUn-LfUJmMkF0JP2PkT7BrQ6yxCbmZlSZhwsd643iEYdP2iC0wPmSy3Z99W1G6re_liTjK7vyxmtwQfaOnpVHZhJlma0_7mFwGEHE3BWL2wSpt15rvXB1A",
    "client_id": "1cc23824-55ca-4635-8048-76a2d8b69130",
    "expires_in": "28799",
    "expires_on": "1578476297",
    "ext_expires_in": "28799",
    "not_before": "1578447197",
    "resource": "https://management.azure.com/",
    "token_type": "Bearer"
}

curl https://management.azure.com/subscriptions/1e25beac-0bd5-4dbe-a039-755b538c7938/resourceGroups/rg-wp-prod-westus2-001?api-version=2016-09-01 -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSIsImtpZCI6InBpVmxsb1FEU01LeGgxbTJ5Z3FHU1ZkZ0ZwQSJ9.eyJhdWQiOiJodHRwczovL21hbmFnZW1lbnQuYXp1cmUuY29tLyIsImlzcyI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2YzOWUxZjc0LTY0M2QtNDNkZC05NDljLTZiNzY0MGMyNTVmZC8iLCJpYXQiOjE1Nzg0NDcxOTcsIm5iZiI6MTU3ODQ0NzE5NywiZXhwIjoxNTc4NDc2Mjk3LCJhaW8iOiI0Mk5nWUdnNTg5cWtvMytLellGdkxrejYrZTA4QUE9PSIsImFwcGlkIjoiMWNjMjM4MjQtNTVjYS00NjM1LTgwNDgtNzZhMmQ4YjY5MTMwIiwiYXBwaWRhY3IiOiIyIiwiaWRwIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvZjM5ZTFmNzQtNjQzZC00M2RkLTk0OWMtNmI3NjQwYzI1NWZkLyIsIm9pZCI6ImY5M2MyMGM1LWU2NjgtNDcxNC1hMjMzLWY0Nzk0MjA0OWU5MSIsInN1YiI6ImY5M2MyMGM1LWU2NjgtNDcxNC1hMjMzLWY0Nzk0MjA0OWU5MSIsInRpZCI6ImYzOWUxZjc0LTY0M2QtNDNkZC05NDljLTZiNzY0MGMyNTVmZCIsInV0aSI6Ii1JQXJqbHIyR1VtSGdYZF82Q01OQUEiLCJ2ZXIiOiIxLjAiLCJ4bXNfbWlyaWQiOiIvc3Vic2NyaXB0aW9ucy8xZTI1YmVhYy0wYmQ1LTRkYmUtYTAzOS03NTViNTM4Yzc5MzgvcmVzb3VyY2Vncm91cHMvcmctd3AtcHJvZC13ZXN0dXMyLTAwMS9wcm92aWRlcnMvTWljcm9zb2Z0Lk1hbmFnZWRJZGVudGl0eS91c2VyQXNzaWduZWRJZGVudGl0aWVzL3VhaS1iYXN0aW9uLXdwLXByb2Qtd2VzdHVzMiJ9.oUcMFmcW0Si8uzMr8bQIoml08Nv1PX2VpTKskNNiENdOcN_ULNEDcdNLFdKZht28FW4Njxh6Mo_JjydjksULlzGS5DQzzekajjlqLgiohBIiCXCQLLJKhx8X1QjszLqwa5ZqurRe72jMhy1zfoo7cFu7iO3PWOniS_sHfCYf1lLbUgTwkTSVv-5XMP-XLiqbLqf4dKhdC4Vj3t7SY2ynTO8Lz4ZClsDhYUn-LfUJmMkF0JP2PkT7BrQ6yxCbmZlSZhwsd643iEYdP2iC0wPmSy3Z99W1G6re_liTjK7vyxmtwQfaOnpVHZhJlma0_7mFwGEHE3BWL2wSpt15rvXB1A"

curl -H Metadata:true "http://169.254.169.254/metadata?api-version=2017-08-01"

# install CLI https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
