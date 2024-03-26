/*
Task 3: Create the load balancer
Task 4: Create load balancer resources
*/

param location_eastus string = 'eastus'
param virtualNetwork_Name string = 'IntLB-VNet'
param virtualNetworks_myFrontEndSubnet_Name string = 'myFrontEndSubnet'
param loadBalancer_Internal_Name string = 'myIntLoadBalancer'
param loadBalancer_Internal_FrontendIPConfiguration_Name string = 'LoadBalancerFrontEnd'
param loadBalancer_Internal_Probe_Name  string = 'myHealthProbe'

resource loadBalancer_Internal 'Microsoft.Network/loadBalancers@2023-05-01' = {
  name: loadBalancer_Internal_Name
  location: location_eastus
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancer_Internal_FrontendIPConfiguration_Name
        properties: {
          privateIPAddress: '10.1.2.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetwork_Name, virtualNetworks_myFrontEndSubnet_Name)
          }
        }
        zones: [
          '3'
          '2'
          '1'
        ]
      }
    ]
    backendAddressPools: [
      {
        name: 'IntLB-VNet_myVMnic1ipconfig1'
        properties:  {}
      }
      {
        name: 'IntLB-VNet_myMV2nic2ipconfig1'
        properties:  {}
      }
      {
        name: 'IntLB-VNet_myVMnic3ipconfig1'
        properties:  {}
      }
    ]
    loadBalancingRules: [
      {
        name: 'myHTTPRule'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', loadBalancer_Internal_Name, loadBalancer_Internal_FrontendIPConfiguration_Name)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancer_Internal_Name, 'IntLB-VNet_myVMnic1ipconfig1')
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 15
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancer_Internal_Name, loadBalancer_Internal_Probe_Name)
          }
        }
      }
    ]
    probes: [
      {
        name: loadBalancer_Internal_Probe_Name
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 10
          numberOfProbes: 1
        }
      }
    ]
  }
}
