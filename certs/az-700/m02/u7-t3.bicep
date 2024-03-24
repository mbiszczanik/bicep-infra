/*
Task 3: Connect a VNet to the Virtual Hub
*/
param virtualHub_name string = 'ContosoVirtualWANHub-WestUS'
param virtualHub_VNETConnection_Name string = 'ContosoVirtualWAN-to-ResearchVNet'

resource virtualHub_VNETConnection 'Microsoft.Network/virtualHubs/hubVirtualNetworkConnections@2023-09-01' = {
  name: '${virtualHub_name}/${virtualHub_VNETConnection_Name}'
}

