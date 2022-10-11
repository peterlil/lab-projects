targetScope = 'subscription'

// Resource group
param location string
param resourceGroupName string
param fnAppNamePrefix string
param appInsightsName string
param laWsName string
param appRegClientId string



resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

module funcApp 'modules/function-app.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'Function-App'
  params: {
    appInsightsName: appInsightsName
    fnAppNamePrefix: fnAppNamePrefix
    laWsName: laWsName
    location: rg.location
    appRegClientId: appRegClientId
  }
}


/*
az deployment sub create `
  --location 'centralus' `
  --name "full-deployment-$(Get-Date -format 'yyyy-MM-dd_hhmmss')" `
  -f main.bicep `
  -p main.parameters.json
*/
