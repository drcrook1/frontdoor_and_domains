@allowed([ 'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS' ])
param skuName string = 'Standard_LRS'
param name string = 'blobstorage'
param location string = 'eastus'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  kind: 'BlobStorage'
  properties: {
    accessTier: 'Cool'
    allowBlobPublicAccess: true
    supportsHttpsTrafficOnly: false
  }
}

resource blobStorage 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
  }
}

var storageHostName = replace(storageAccount.properties.primaryEndpoints.blob, 'https://', '')

output storageHostName string = replace(storageHostName, '/', '')
