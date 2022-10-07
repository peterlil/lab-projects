targetScope = 'subscription'

// Resource group
param location string
param resourceGroupName string
param fnAppName string
param appInsightsName string
param laWsName string



resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

module funcApp 'modules/function-app.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'Function-App'
  params: {
    appInsightsName: appInsightsName
    fnAppName: fnAppName
    laWsName: laWsName
    location: rg.location
  }
}


/*
az deployment sub create `
  --location 'centralus' `
  --name "full-deployment-$(Get-Date -format 'yyyy-MM-dd_hhmmss')" `
  -f main.bicep `
  -p main.parameters.json
*/
