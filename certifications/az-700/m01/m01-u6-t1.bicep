/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01 - Unit 6 Configure DNS settings in Azure; Task 1: Create a private DNS Zone
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/6-exercise-configure-domain-name-servers-configuration-azure
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M01-Unit%206%20Configure%20DNS%20settings%20in%20Azure.html
     
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param privateDnsZone_Name string = 'contoso.com'

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
  CostCenter: '00001'
  MSDN: 'MSDN'
}

////////////////////////////////// RESOURCES //////////////////////////////////

// Task 1: Create a private DNS Zone
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZone_Name
  location: 'global'
  tags: tags
}

//////////////////////////////////  OUTPUT  //////////////////////////////////

//////////////////////////////////  PARAMETERS //////////////////////////////////

//////////////////////////////////  VARIABLES //////////////////////////////////

////////////////////////////////// RESOURCES //////////////////////////////////

//////////////////////////////////  OUTPUT  //////////////////////////////////
