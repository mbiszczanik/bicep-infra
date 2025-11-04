$location = 'swedencentral'
$resourceGroupName = 'd-avm-swc-rg-01'
$publicIP = (Invoke-WebRequest -Uri "http://ifconfig.me/ip").Content.Trim()

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if (-not $resourceGroup) {
    Write-Host "The Resource Group does not exist. Creating..." -ForegroundColor Yellow
    New-AzResourceGroup -Name $resourceGroupName -Location $location
    Write-Host "Resource Group created, moving on..." -ForegroundColor Green
} else {
    Write-Host "The Resource Group already exists. Skip creation." -ForegroundColor Green
}

# Get public IP address
Write-Host "Your public IP address is: $publicIP" -ForegroundColor Cyan
$myIPParamObject = @{
    parMyPublicIP = "$publicIP/32"
}

New-AzResourceGroupDeployment `
-Name "Azure-Verified-Modules" `
-ResourceGroupName $resourceGroupName `
-TemplateFile ..\bicep\avm-main.bicep `
-TemplateParameterObject $myIPParamObject `
-Verbose