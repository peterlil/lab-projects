param location string
param laWsName string
param acaEnvironmentName string
param acaAppName string
param acaTargetPort int

resource logAnalyticsWs 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: laWsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource acaEnvironment 'Microsoft.App/managedEnvironments@2022-06-01-preview' = {
  name: acaEnvironmentName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: laWsName
      logAnalyticsConfiguration: {
        customerId: logAnalyticsWs.properties.customerId
        sharedKey: listkeys(logAnalyticsWs.id, logAnalyticsWs.apiVersion).primarySharedKey
      }
    }
    vnetConfiguration: {
      internal: false
    }
  }
}

resource acaApp 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: acaAppName
  location: location
  identity: {
    
  }
  properties: {
    managedEnvironmentId: acaEnvironment.id
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        allowInsecure: false
        targetPort: acaTargetPort
        external: true
      }
    }
    template: {
      
    }
  }
}
