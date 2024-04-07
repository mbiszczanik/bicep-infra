param trafficManagerProfiles_Contoso_TMProfilebs_name string = 'Contoso-TMProfilebs'
param sites_ContosoWebAppEastUSbs_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/Contoso-RG-TM1/providers/Microsoft.Web/sites/ContosoWebAppEastUSbs'
param sites_ContosoWebAppWestEuropebs_externalid string = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/Contoso-RG-TM2/providers/Microsoft.Web/sites/ContosoWebAppWestEuropebs'

resource trafficManagerProfiles_Contoso_TMProfilebs_name_resource 'Microsoft.Network/trafficManagerProfiles@2022-04-01' = {
  name: trafficManagerProfiles_Contoso_TMProfilebs_name
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Priority'
    dnsConfig: {
      relativeName: 'contoso-tmprofilebs'
      ttl: 60
    }
    monitorConfig: {
      profileMonitorStatus: 'CheckingEndpoints'
      protocol: 'HTTP'
      port: 80
      path: '/'
      intervalInSeconds: 30
      toleratedNumberOfFailures: 3
      timeoutInSeconds: 10
    }
    endpoints: [
      {
        id: '${trafficManagerProfiles_Contoso_TMProfilebs_name_resource.id}/azureEndpoints/myPrimaryEndpoint'
        name: 'myPrimaryEndpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          endpointStatus: 'Enabled'
          endpointMonitorStatus: 'CheckingEndpoint'
          targetResourceId: sites_ContosoWebAppEastUSbs_externalid
          target: 'contosowebappeastusbs.azurewebsites.net'
          weight: 1
          priority: 1
          endpointLocation: 'East US'
          alwaysServe: 'Disabled'
        }
      }
      {
        id: '${trafficManagerProfiles_Contoso_TMProfilebs_name_resource.id}/azureEndpoints/myFailoverEndpoint'
        name: 'myFailoverEndpoint'
        type: 'Microsoft.Network/trafficManagerProfiles/azureEndpoints'
        properties: {
          endpointStatus: 'Enabled'
          endpointMonitorStatus: 'CheckingEndpoint'
          targetResourceId: sites_ContosoWebAppWestEuropebs_externalid
          target: 'contosowebappwesteuropebs.azurewebsites.net'
          weight: 1
          priority: 2
          endpointLocation: 'West Europe'
          alwaysServe: 'Disabled'
        }
      }
    ]
    trafficViewEnrollmentStatus: 'Disabled'
    maxReturn: 0
  }
}
