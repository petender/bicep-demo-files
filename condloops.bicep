@minLength(3)
@maxLength(11)
param storagePrefix string

param storageCount int = 5 

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location
param appServicePlanName string = 'exampleplan'

@minLength(2)
@description('Base name of the resource such as web app name and app service plan.')
param webAppName string

@description('The Runtime stack of current web app.')
param linuxFxVersion string = 'php|7.0'

param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}


var webAppPortalName = '${webAppName}${uniqueString(resourceGroup().id)}'

resource storageAcct 'Microsoft.Storage/storageAccounts@2019-04-01' = [for i in range(0, storageCount): {
  name: '${i}storage${uniqueString(resourceGroup().id)}'
  location: location
  tags: resourceTags
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}]

resource appPlan 'Microsoft.Web/serverfarms@2016-09-01' = {
  name: appServicePlanName
  location: location
  tags: resourceTags
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource site 'Microsoft.Web/sites@2016-08-01' = {
  name: webAppPortalName
  location: location
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: appPlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

