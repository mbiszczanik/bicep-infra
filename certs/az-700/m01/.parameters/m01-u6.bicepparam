using '../m01-u6.bicep'

param location = resourceGroup().location
param virtualMachine_1_Name = 'TestVM1'
param virtualMachine_2_Name = 'TestVM2'
param virtualMachine_AdminUsername = 'administrrator'
param virtualMachine_AdminPassword = ''
param networkInterface_1_Name = '${virtualMachine_1_Name}-NIC'
param networkInterface_2_Name = '${virtualMachine_2_Name}-NIC'
param networkSecurityGroup_1_Name = '${virtualMachine_1_Name}-NSG'
param networkSecurityGroup_2_Name = '${virtualMachine_2_Name}-NSG'
param publicIPAdress_1_Name = '${virtualMachine_1_Name}-PIP'
param publicIPAdress_2_Name = '${virtualMachine_2_Name}-PIP'
param privateDNSZone_Name = 'contoso.com'
param virtualNetworkLink_Name = 'CoreServicesVnetLink'
param virtualNetworkLink_AutoVmRegistration = true

