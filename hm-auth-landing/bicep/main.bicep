targetScope = 'subscription'

// Resource group
param location string
param resourceGroupName string

// Azure Container Apps
param acaEnvironmentName string


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}


