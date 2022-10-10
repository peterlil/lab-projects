param location string
param keyVaultName string
param sku string
param objectIdOfUser string
param enabledForDeployment bool
param enabledForTemplateDeployment bool
param enabledForDiskEncryption bool

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  location: location
  name: keyVaultName
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    sku: {
      name: sku
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies:[
      {
        objectId: objectIdOfUser
        tenantId: subscription().tenantId
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'backup'
            'restore'
          ]
          secrets:[
            'all'
          ]
          certificates: [
            'all'
          ]
        }
      }
    ]
  }
}
