param location string = 'northeurope'
param envName string = 'apis-cappenv'
param lawsName string = 'laws-ne'
param lawsRg string = 'apim'
param appName string = 'petapi'

var acrPullRole = resourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')

resource laws 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
    name: lawsName
    scope: resourceGroup(lawsRg)
}

resource env 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: envName
  location: location
  properties: {
    appLogsConfiguration: {
        destination: 'log-analytics'
        logAnalyticsConfiguration: {
            customerId: laws.properties.customerId
            sharedKey: laws.listKeys().primarySharedKey
        }
    }
    infrastructureResourceGroup: '${envName}-infra'
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
        //maximumCount: 1
        //minimumCount: 1
      }
    ]
    zoneRedundant: false
  }
}

resource uai 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31' = {
  name: 'id-${appName}'
  location: location
}

@description('This allows the managed identity of the container app to access the registry, note scope is applied to the wider ResourceGroup not the ACR')
resource uaiRbac 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, uai.id, acrPullRole)
  properties: {
    roleDefinitionId: acrPullRole
    principalId: uai.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource app 'Microsoft.App/containerApps@2024-03-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${uai.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: env.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        allowInsecure: false
      }
      
    }
  }
}
