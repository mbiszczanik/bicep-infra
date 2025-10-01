param sites_ContosoWebAppEastUSbs_name string = 'ContosoWebAppEastUSbs'
param serverfarms_ASP_ContosoRGTM1_9728_name string = 'ASP-ContosoRGTM1-9728'

resource serverfarms_ASP_ContosoRGTM1_9728_name_resource 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: serverfarms_ASP_ContosoRGTM1_9728_name
  location: 'East US'
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_ContosoWebAppEastUSbs_name_resource 'Microsoft.Web/sites@2023-01-01' = {
  name: sites_ContosoWebAppEastUSbs_name
  location: 'East US'
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'contosowebappeastusbs.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'contosowebappeastusbs.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_ContosoRGTM1_9728_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '92D76DE0BED624EB61B8D29687A81D060A43663A5993BD283F69B551D1B91E6D'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_ContosoWebAppEastUSbs_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_ContosoWebAppEastUSbs_name_resource
  name: 'ftp'
  location: 'East US'
  properties: {
    allow: false
  }
}

resource sites_ContosoWebAppEastUSbs_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_ContosoWebAppEastUSbs_name_resource
  name: 'scm'
  location: 'East US'
  properties: {
    allow: false
  }
}

resource sites_ContosoWebAppEastUSbs_name_web 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: sites_ContosoWebAppEastUSbs_name_resource
  name: 'web'
  location: 'East US'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$ContosoWebAppEastUSbs'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_ContosoWebAppEastUSbs_name_sites_ContosoWebAppEastUSbs_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-01-01' = {
  parent: sites_ContosoWebAppEastUSbs_name_resource
  name: '${sites_ContosoWebAppEastUSbs_name}.azurewebsites.net'
  location: 'East US'
  properties: {
    siteName: 'ContosoWebAppEastUSbs'
    hostNameType: 'Verified'
  }
}



///////////////////////////////////////////////////////////////////////////////////////////////////

param sites_ContosoWebAppWestEuropebs_name string = 'ContosoWebAppWestEuropebs'
param serverfarms_ASP_ContosoRGTM2_a4b6_name string = 'ASP-ContosoRGTM2-a4b6'

resource serverfarms_ASP_ContosoRGTM2_a4b6_name_resource 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: serverfarms_ASP_ContosoRGTM2_a4b6_name
  location: 'West Europe'
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource sites_ContosoWebAppWestEuropebs_name_resource 'Microsoft.Web/sites@2023-01-01' = {
  name: sites_ContosoWebAppWestEuropebs_name
  location: 'West Europe'
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'contosowebappwesteuropebs.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'contosowebappwesteuropebs.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_ContosoRGTM2_a4b6_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: true
      http20Enabled: false
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '92D76DE0BED624EB61B8D29687A81D060A43663A5993BD283F69B551D1B91E6D'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_ContosoWebAppWestEuropebs_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_ContosoWebAppWestEuropebs_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_ContosoWebAppWestEuropebs_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-01-01' = {
  parent: sites_ContosoWebAppWestEuropebs_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_ContosoWebAppWestEuropebs_name_web 'Microsoft.Web/sites/config@2023-01-01' = {
  parent: sites_ContosoWebAppWestEuropebs_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v4.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$ContosoWebAppWestEuropebs'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: true
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: true
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_ContosoWebAppWestEuropebs_name_sites_ContosoWebAppWestEuropebs_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2023-01-01' = {
  parent: sites_ContosoWebAppWestEuropebs_name_resource
  name: '${sites_ContosoWebAppWestEuropebs_name}.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'ContosoWebAppWestEuropebs'
    hostNameType: 'Verified'
  }
}
