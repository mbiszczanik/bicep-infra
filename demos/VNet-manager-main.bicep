/*
SUMMARY: Vnet Manager demo
DESCRIPTION: n/a
AUTHOR/S: Marcin Biszczanik
VERSION: 0.1.0
*/

targetScope = 'subscription'

//////////////////////////////////  PARAMETERS //////////////////////////////////
param par_Location_01 string = 'westeurope'
param par_Location_02 string = 'northeurope'

@secure()
param par_VirtualMachine_Admin_Password string

//////////////////////////////////  VARIABLES //////////////////////////////////
var var_VirtualNetwork_Hub01_ResourceGroup_Name = 'Hub01-WEU-VNET-RG'
var var_VirtualNetwork_Spoke01_ResourceGroup_Name = 'Spoke01-WEU-VNET-RG'
var var_VirtualNetwork_Spoke02_ResourceGroup_Name = 'Spoke02-WEU-VNET-RG'

var var_VirtualNetwork_Hub01_Name = 'Hub01-WEU-VNET01'
var var_VirtualNetwork_Spoke01_Name = 'Spoke01-WEU-VNET01'
var var_VirtualNetwork_Spoke02_Name = 'Spoke02-WEU-VNET01'
var var_VirtualNetwork_Manager_Name = 'Hub01-WEU-AVNM01'
var var_VirtualMachine_Name = 'TestVM01'

var var_Tags = {
  Environment: 'Training'
  CostCenter: 'MSDN'
}

var var_VNet_Manager_Subscription_ID = subscription().subscriptionId

////////////////////////////////// RESOURCES //////////////////////////////////

module mod_ResourceGroup_Hub01 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Hub01_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Hub01_ResourceGroup_Name
    location: par_Location_01
    tags: var_Tags
  }
}

module mod_ResourceGroup_Spoke01 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Spoke01_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Spoke01_ResourceGroup_Name
    location: par_Location_02
    tags: var_Tags
  }
}

module mod_ResourceGroup_Spoke02 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Spoke02_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Spoke02_ResourceGroup_Name
    location: par_Location_02
    tags: var_Tags
  }
}

module mod_VirtualNetwork_Hub01 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Hub01.name)
  name: var_VirtualNetwork_Hub01_Name
  params: {
    name: var_VirtualNetwork_Hub01_Name
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'ContosoSubnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    tags: var_Tags
  }
}

module mod_virtualNetwork_Spoke01 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Spoke01.name)
  name: var_VirtualNetwork_Spoke01_Name
  params: {
    name: var_VirtualNetwork_Spoke01_Name
    addressPrefixes: [
      '10.1.0.0/16'
    ]
    tags: var_Tags
    subnets: [
      {
        name: 'FabrikamSubnet'
        addressPrefix: '10.1.1.0/24'
      }
    ]
  }
}

module mod_VirtualNetwork_Spoke02 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Spoke02.name)
  name: var_VirtualNetwork_Spoke02_Name
  params: {
    name: var_VirtualNetwork_Spoke02_Name
    addressPrefixes: [
      '10.2.0.0/16'
    ]
    tags: var_Tags
    subnets: [
      {
        name: 'TailwindSubnet'
        addressPrefix: '10.2.1.0/24'
      }
    ]
  }
}

//////////////////////////////////  Network Manager  //////////////////////////////////
module mod_VirtualNetwork_Manager_Contoso 'br/public:avm/res/network/network-manager:0.4.0' = {
  scope: resourceGroup(mod_ResourceGroup_Hub01.name)
  name: var_VirtualNetwork_Manager_Name
  params: {
    name: var_VirtualNetwork_Manager_Name
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
    networkManagerScopes: {
      subscriptions: [
        '/subscriptions/${var_VNet_Manager_Subscription_ID}'
      ]
    }
  }
}

//////////////////////////////////  Virtual Machine  //////////////////////////////////
module mod_VirtualMachine_Windows 'br/public:avm/res/compute/virtual-machine:0.9.0' = {
  scope: resourceGroup(mod_ResourceGroup_Hub01.name)
  name: var_VirtualMachine_Name
  params: {
    name: var_VirtualMachine_Name
    adminUsername: '${var_VirtualMachine_Name}Admin'
    adminPassword: par_VirtualMachine_Admin_Password
    imageReference: {
      offer: 'WindowsServer'
      publisher: 'MicrosoftWindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    nicConfigurations: [
      {
        ipConfigurations: [
          {
            name: 'ipconfig01'
            subnetResourceId: '${mod_VirtualNetwork_Hub01.outputs.subnetResourceIds}'
          }
        ]
        nicSuffix: '-nic-01'
        enableAcceleratedNetworking: false
      }
    ]
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'StandardSSD_LRS'
      }
    }
    osType: 'Windows'
    vmSize: 'Standard_B2ms'
    zone: 0
    encryptionAtHost: false
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
