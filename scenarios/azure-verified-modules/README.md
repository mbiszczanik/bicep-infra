# Azure Verified Modules — README

Short description
- Repository of Bicep scenarios demonstrating usage of verified modules for Azure infrastructure.

Contents
- /bicep — reusable Bicep code
- /scripts — helper scripts for build and deployment
- readme.md — this file

Prerequisites
- Azure CLI (az) >= latest stable
- Bicep CLI or Azure CLI with Bicep support
- PowerShell (Windows) or Bash (Linux/macOS) for scripts
- Appropriate Azure subscription and permissions to create resources

Quick start
1. Login:
    - Connect-AzAccount
2. Select subscription:
    - Set-AzContext -SubscriptionId "<subscription-id>"
4. Deploy:
    - ./scripts/Deploy-Infra.ps1
5. Verify:
    - If failed check KeyVault and add access and password for vm deployment
