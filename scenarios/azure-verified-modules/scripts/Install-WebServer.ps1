Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
Install-WindowsFeature -Name Web-Asp-Net45 -IncludeAllSubFeature

# Create HTML page
$htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Demo Server</title>
</head>
<body>
    <h1>Azure VM Automated Setup Complete!</h1>
    <p>Server configured on: $(Get-Date)</p>
    <p>Computer Name: $env:COMPUTERNAME</p>
</body>
</html>
"@

$htmlContent | Out-File -FilePath "C:\inetpub\wwwroot\index.html" -Encoding ASCII

# Ensure IIS is started
Start-Service W3SVC -ErrorAction SilentlyContinue

# Exit successfully
exit 0
