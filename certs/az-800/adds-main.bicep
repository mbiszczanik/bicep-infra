/*######################################################
SUMMARY: 
DESCRIPTION: Basic template for Windows VM for sandbox.
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: 

@@@---------- MANUAL TESTING & DEPLOYMENT ----------@@@

Connect-AzAccount -TenantId <Azure Tenant ID>

Select-AzSubscription <Azure Subscription>

###---------- Development ----------###

New-AzResourceGroupDeployment `
-Name "ADDS" `
-ResourceGroupName "az800-rg01" `
-TemplateFile .\certs\az-800\adds-main.bicep `
-Verbose 

Get-AzResourceGroupDeploymentOperation -ResourceGroupName az800-rg01 -DeploymentName ADDS

######################################################*/

/*******************
*   Target Scope   *
*******************/
targetScope = 'resourceGroup'


/*******************
*    Parameters    *
*******************/
param par_Location string = 'northeurope'

@secure()
param par_AdminPassword string

/*******************
*    Variables     *
*******************/
var var_Tags = {
  Environment: 'Training'
  CostCenter: 'MSDN'
}

var var_VirtualNetwork_Name = 'Az800-NEU-VNET01'
var var_PublicIPAdress_Name01 = 'Az800-NEU-PIP01'
var var_NetworkSecurityGroups_Name01 = 'Az800-NEU-NSG01'
var var_NetworkSecurityGroups_Name02 = 'Az800-NEU-NSG02'
var var_VirtualMachine_Name01 = 'Az800-ADDS01'
var var_VirtualMachine_Name02 = 'Az800-ADDS02'

/*******************
*    Resources     *
*******************/
module mod_VirtualNetwork 'br/public:avm/res/network/virtual-network:0.5.4' = {
  name: var_VirtualNetwork_Name
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'ADDSSubnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
    name: var_VirtualNetwork_Name
    // Non-required parameters
    location: par_Location
    tags: var_Tags
  }
}

module mod_PublicIpAddress01 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: var_PublicIPAdress_Name01
  params: {
    // Required parameters
    name: var_PublicIPAdress_Name01
    // Non-required parameters
    location: par_Location
    publicIPAllocationMethod: 'Static'
    skuName: 'Standard'
    zones: [
      1
      2
      3
    ]
  }
}

module mod_NetworkSecurityGroup01 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: var_NetworkSecurityGroups_Name01
  params: {
    // Required parameters
    name: var_NetworkSecurityGroups_Name01
    // Non-required parameters
    location: par_Location // ADD NSG RULE FOR RDP with IP parameter prompt
  }
}

module mod_NetworkSecurityGroup02 'br/public:avm/res/network/network-security-group:0.5.0' = {
  name: var_NetworkSecurityGroups_Name02
  params: {
    // Required parameters
    name: var_NetworkSecurityGroups_Name02
    // Non-required parameters
    location: par_Location
  }
}

module mod_VirtualMachine_Windows01 'br/public:avm/res/compute/virtual-machine:0.9.0' = {
  name: var_VirtualMachine_Name01
  params: {
    name: var_VirtualMachine_Name01
    adminUsername: '${var_VirtualMachine_Name01}Admin'
    adminPassword: par_AdminPassword
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
            subnetResourceId: mod_VirtualNetwork.outputs.subnetResourceIds[0]
            publicIPAddressResourceId: mod_PublicIpAddress01.outputs.resourceId // Check PIP due to issue with attaching to NIC
          }
        ]
        nicSuffix: '-nic-01'
        enableAcceleratedNetworking: false
        networkSecurityGroupResourceId: mod_NetworkSecurityGroup01.outputs.resourceId
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
    zone: 1
    encryptionAtHost: false
    tags: var_Tags
  }
  dependsOn: [
  ]
}

module mod_VirtualMachine_Windows02 'br/public:avm/res/compute/virtual-machine:0.9.0' = {
  name: var_VirtualMachine_Name02
  params: {
    name: var_VirtualMachine_Name02
    adminUsername: '${var_VirtualMachine_Name02}Admin'
    adminPassword: par_AdminPassword
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
            subnetResourceId: mod_VirtualNetwork.outputs.subnetResourceIds[0]
            // publicIPAddressResourceId: mod_PublicIpAddress02.outputs.resourceId // Check PIP due to issue with attaching to NIC
          }
        ]
        nicSuffix: '-nic-01'
        enableAcceleratedNetworking: false
        networkSecurityGroupResourceId: mod_NetworkSecurityGroup02.outputs.resourceId
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
    zone: 1
    encryptionAtHost: false
    tags: var_Tags
  }
  dependsOn: [
  ]
}

/******************
*     Outputs     *
******************/
output publicIpId string = mod_PublicIpAddress01.outputs.resourceId
output nsgId string = mod_NetworkSecurityGroup01.outputs.resourceId
