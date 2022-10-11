param fnAppName string
param location string
param laWsName string
param appInsightsName string
param appRegClientId string

var hostingPlanName = '${fnAppName}-plan'

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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
    WorkspaceResourceId: logAnalyticsWs.id
  }
}

resource sa 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'azf${uniqueString(fnAppName)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties:{
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: hostingPlanName
  location: location
  kind: 'functionapp'
  properties: {
    targetWorkerSizeId: 0
    targetWorkerCount: 0
    reserved: true  // true=linux
    zoneRedundant: false
  }
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource fnApp 'Microsoft.Web/sites@2022-03-01' = {
  name: fnAppName
  location: location
  kind: 'functionapp'
  tags:{
    'hidden link: /app-insights-resource-id': appInsights.id
  }
  properties: {
    serverFarmId: hostingPlan.id
    httpsOnly: true
    siteConfig: {
      numberOfWorkers: 1
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sa.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sa.listKeys().keys[0].value}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'python'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${sa.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${sa.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(fnAppName)
        }
      ]
      cors:{
        allowedOrigins:[
          'https://ms.portal.azure.com'
        ]
      }
      linuxFxVersion: 'Python|3.9'
      minTlsVersion: '1.2'
    }
  }
}

resource symbolicname 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'authsettingsV2'
  parent: fnApp
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'Return401'
    }
    httpSettings: {
      forwardProxy: {
        convention: 'NoProxy'
      }
      requireHttps: true
      routes: {
        apiPrefix: '/.auth'
      }
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        login: {
          disableWWWAuthenticate: false
        }
        registration: {
          clientId: appRegClientId
          clientSecretSettingName: 'MICROSOFT_PROVIDER_AUTHENTICATION_SECRET'
          openIdIssuer: 'https://sts.windows.net/16b3c013-d300-468d-ac64-7eda0820b6d3/v2.0'
        }
        validation: {
          allowedAudiences: []
          defaultAuthorizationPolicy: {
            allowedPrincipals: { }
          }
          jwtClaimChecks: { }
        }
      }
    }
    login: {
      cookieExpiration: {
        convention: 'FixedTime'
        timeToExpiration: '08:00:00'
      }
      nonce: {
        nonceExpirationInterval: '00:05:00'
        validateNonce: true
      }
      routes: { }
    }
    platform: {
      enabled: true
      runtimeVersion: '~1'
    }
  }
}
