/*
SUMMARY: Vnet Manager demo
DESCRIPTION: n/a
AUTHOR/S: Marcin Biszczanik
VERSION: 0.1.0

***---------- DEPLOYMENT ----------***
Connect-AzAccount
###---------- Staging ----------###
Select-AzSubscription 

New-AzSubscriptionDeployment `
-Name "VNet-Manager-demo" `
-TemplateFile .\demos\VNet-manager-main.bicep `
-Location "North Europe" `
-Verbose

*/

targetScope = 'subscription'

//////////////////////////////////  PARAMETERS //////////////////////////////////
param par_Location_01 string = 'westeurope'
param par_Location_02 string = 'northeurope'

@secure()
param par_VirtualMachine_Admin_Password string

//////////////////////////////////  VARIABLES //////////////////////////////////
var var_VirtualNetwork_Contoso_ResourceGroup_Name = 'Contoso-WEU-VNET-RG'
var var_VirtualNetwork_Fabrikam_ResourceGroup_Name = 'Fabrikam-WEU-VNET-RG'
var var_VirtualNetwork_Tailwind_ResourceGroup_Name = 'Tailwind-WEU-VNET-RG'

var var_VirtualNetwork_Contoso_Name = 'Contoso-WEU-VNET01'
var var_VirtualNetwork_Fabrikam_Name = 'Fabrikam-WEU-VNET01'
var var_VirtualNetwork_Tailwind_Name = 'Tailwind-WEU-VNET01'
var var_VirtualNetwork_Manager_Contoso_Name = 'Contoso-WEU-VNM01'
var var_VirtualMachine_Name = 'TestContosoVM'

var var_Tags = {
  Environment: 'Training'
  CostCenter: 'MSDN'
}

var var_VNet_Manager_Subscription_ID = subscription().subscriptionId

////////////////////////////////// RESOURCES //////////////////////////////////

module mod_ResourceGroup_Contoso 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Contoso_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Contoso_ResourceGroup_Name
    location: par_Location_01
    tags: var_Tags
  }
}

module mod_ResourceGroup_Fabrikam 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Fabrikam_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Fabrikam_ResourceGroup_Name
    location: par_Location_02
    tags: var_Tags
  }
}

module mod_ResourceGroup_Tailwind 'br/public:avm/res/resources/resource-group:0.4.0' = {
  name: var_VirtualNetwork_Tailwind_ResourceGroup_Name
  params: {
    name: var_VirtualNetwork_Tailwind_ResourceGroup_Name
    location: par_Location_02
    tags: var_Tags
  }
}

module mod_VirtualNetwork_Contoso 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Contoso.name)
  name: var_VirtualNetwork_Contoso_Name
  params: {
    name: var_VirtualNetwork_Contoso_Name
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

module mod_virtualNetwork_Fabrikam 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Fabrikam.name)
  name: var_VirtualNetwork_Fabrikam_Name
  params: {
    name: var_VirtualNetwork_Fabrikam_Name
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

module mod_VirtualNetwork_Tailwind 'br/public:avm/res/network/virtual-network:0.5.1' = {
  scope: resourceGroup(mod_ResourceGroup_Tailwind.name)
  name: var_VirtualNetwork_Tailwind_Name
  params: {
    name: var_VirtualNetwork_Tailwind_Name
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
  scope: resourceGroup(mod_ResourceGroup_Contoso.name)
  name: 'vnetManager' // var_VirtualNetwork_Manager_Contoso_Name
  params: {
    name: 'vnetManager' // var_VirtualNetwork_Manager_Contoso_Name
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
  scope: resourceGroup(mod_ResourceGroup_Contoso.name)
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
            subnetResourceId: '${mod_VirtualNetwork_Contoso.outputs.subnetResourceIds}'
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
