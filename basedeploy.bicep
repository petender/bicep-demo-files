
param resourceTags object = {
  Environment: 'Dev'
  Project: 'Tutorial'
}


resource stg 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: 'pdtbicepteststo12300'
  location: 'centralus'
  tags: resourceTags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}

resource appPlan 'Microsoft.Web/serverfarms@2016-09-01' = {
  name: 'pdtdemobicepapppppplan'
  location: 'centralus'
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
    name: 'pdtdemobicepappplan'
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource site 'Microsoft.Web/sites@2016-08-01' = {
  name: 'pdtbicepdemowebapp000'
  location: 'centralus'
  tags: resourceTags
  kind: 'app'
  properties: {
    serverFarmId: appPlan.id
    siteConfig: {
      linuxFxVersion: 'php|7.0'
    }
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints
