# Install IIS and common features
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole, IIS-WebServer, IIS-CommonHttpFeatures, IIS-HttpErrors, IIS-HttpLogging, IIS-RequestFiltering, IIS-StaticContent

# Install ASP.NET features
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45, IIS-ISAPIExtensions, IIS-ISAPIFilter, IIS-ASPNET45

# Create a simple HTML page
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

# Start IIS service
Start-Service W3SVC
