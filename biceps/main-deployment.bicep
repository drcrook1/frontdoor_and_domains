targetScope = 'subscription'

param location string = 'eastus'
param resourcePrefix string = 'dacrook'

resource rg_global 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${resourcePrefix}-global'
  location: location
}

module keyvault './keyvault.bicep' = {
  name: '${resourcePrefix}kv'
  scope: rg_global
  params: {
    location: location
    name: '${resourcePrefix}kv'
  }
}

module blobStorage './storage.bicep' = {
  name: '${resourcePrefix}storage'
  scope: rg_global
  params: {
    skuName: 'Standard_LRS'
    name: '${resourcePrefix}blobs'
    location: location
  }
}

module frontdoor './frontdoor.bicep' = {
  name: '${resourcePrefix}fd'
  scope: rg_global
  params: {
    profileName: '${resourcePrefix}fd'
    originStorageHostName: blobStorage.outputs.storageHostName
  }
}
