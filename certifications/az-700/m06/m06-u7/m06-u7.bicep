/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: 
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M06-Unit%207%20Deploy%20and%20configure%20Azure%20Firewall%20using%20the%20Azure%20portal.html

# Resource Group
New-AzResourceGroup -Name 'Test-FW-RG' -Location 'eastus'
Remove-AzResourceGroup -Name 'Test-FW-RG' -Force -AsJob

# Deployment
New-AzResourceGroupDeployment `
-Name 'Firewall' `
-ResourceGroupName 'Test-FW-RG' `
-TemplateFile .\m06-u7.bicep `
-Verbose

*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param location_eastus string = 'eastus'

param virtualNetwork_Name string = 'Test-FW-VN'

//////////////////////////////////  VARIABLES //////////////////////////////////

////////////////////////////////// RESOURCES //////////////////////////////////

// Task 2: Create a virtual network and subnets

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetwork_Name
  location: location_eastus
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: '10.0.1.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'Workload-SN'
        properties: {
          addressPrefix: '10.0.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

// Task 4: Deploy the firewall and firewall policy

resource publicIPAdress_Firewall 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: 'fw-pip'
  location: location_eastus
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-05-01' = {
  name: 'Test-FW01'
  location: location_eastus
  properties: {
    ipConfigurations: [
      {
        name: 'FirewallIPConfiguration'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'Test-FW-VN', 'AzureFirewallSubnet')
          }
          publicIPAddress: {
            id: publicIPAdress_Firewall.id
          }
        }
      }
    ]
    firewallPolicy: {
      id: firewallPolicy.id
    }
    sku: {
      name: 'AZFW_VNet'
      tier: 'Premium'
    }
  }
}

resource firewallPolicy 'Microsoft.Network/firewallPolicies@2023-05-01' = {
  name: 'fw-test-pol'
  location: location_eastus
  properties: {
    sku: {
      tier: 'Standard'
    }
    dnsSettings: {
      enableProxy: true
    }
    threatIntelMode: 'Alert'
  }
}

// Task 5: Create a default route aka Route Table

resource WorkerRoute 'Microsoft.Network/routeTables@2020-05-01' = {
  name: 'fw-dg'
  location: location_eastus
  properties: {
    routes: [
      {
        name: 'fw-dg'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.1.4'
        }
      }
    ]
    disableBgpRoutePropagation: false
  }
}


resource firewallRule 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2023-05-01' = {
  parent: firewallPolicy
  name: 'App-Coll01'
  properties: {
    priority: 200
    ruleCollections: [
      // Task 6: Configure an application rule
      // NOT WORKING, TO CHECK!
      // {
      //   ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
      //   name: 'App-Coll01'
      //   priority: 200
      //   action: {
      //     type: 'Allow'
      //   }
      //   rules: [
      //     {
      //       ruleType: 'ApplicationRule'
      //       name: 'Allow-Google'
      //       sourceAddresses: [
      //         '10.0.2.0/24'
      //       ]
      //       protocols: [
      //         {
      //           port: 80
      //           protocolType: 'Http'
      //         }
      //         {
      //           port: 443
      //           protocolType: 'Https'
      //         }
      //       ]
      //       targetFqdns: [
      //         '*google.com'
      //       ]
      //     }
      //   ]
      // }
      // Task 7: Configure a network rule
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        name: 'Net-Coll01'
        priority: 200
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'Allow-DNS'
            ipProtocols: [
              'UDP'
            ]
            sourceAddresses: [
              '10.0.2.0/24'
            ]
            sourceIpGroups: []
            destinationAddresses: [
              '109.244.0.3'
              '209.244.0.4'
            ]
            destinationIpGroups: []
            destinationFqdns: []
            destinationPorts: [
              '53'
            ]
          }
        ]
      }
      // Task 8: Configure a Destination NAT (DNAT) rule
      // {
      //   ruleCollectionType: 'FirewallPolicyNatRuleCollection'
      //   name: 'rdp'
      //   priority: 200
      //   rules: [
      //     {
      //       ruleType: 'NatRule'
      //       name: 'rdp-nat'
      //       sourceAddresses: [
      //         '*'
      //       ]
      //       ipProtocols: [
      //         'TCP'
      //       ]
      //       destinationPorts: [
      //         '3389'
      //       ]
      //       destinationAddresses: [
      //         '172.206.194.17' // publicIPAdress_Firewall
      //       ]
      //       translatedAddress: '10.0.2.4' // Srv-Work private IP address
      //       translatedPort: '3389'
      //     }
      //   ]
      // }
    ]
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
