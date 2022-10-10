targetScope = 'subscription'

// Resource group
param location string
param resourceGroupName string
param userObjectId string


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

module funcApp 'modules/keyvault.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'Key-Vault'
  params: {
    location: location
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    keyVaultName: 'akv${uniqueString(resourceGroupName)}'
    objectIdOfUser: userObjectId
    sku: 'standard'
  }
}


/*
az deployment sub create `
  --location 'centralus' `
  --name "full-deployment-$(Get-Date -format 'yyyy-MM-dd_hhmmss')" `
  -f main.key-vault.bicep `
  -p main.key-vault.parameters.json
*/
