
# bicep-infra: Azure Bicep Infrastructure Portfolio

Welcome! This repository is a comprehensive test and demonstration environment for Azure Bicep infrastructure as code. It is designed as a portfolio to showcase modular, reusable, and production-ready Bicep templates for a variety of real-world scenarios, certifications, and demos.

## 🚀 Features
- Modular Bicep templates for compute, network, monitoring, security, and more
- Demo environments for Azure certifications (e.g., AZ-700, AZ-800)
- Real-world scenarios: AVNM, network troubleshooting, VM deployments, AKS, and more
- Example deployment scripts (PowerShell, Azure CLI)
- Ready-to-use parameter files and documentation
- CI/CD pipeline samples

## 📂 Repository Structure
- `modules/` — Reusable Bicep modules (compute, network, monitor, etc.)
- `scenarios/` — Hands-on demo environments and labs
- `certifications/` — Certification-aligned scenarios (AZ-700, AZ-800)
- `.azure-pipelines/` — Azure CI/CD pipeline templates
- `core-main.bicep` — Example main deployment

## 🏁 Quick Start
### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or [Azure PowerShell](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)

### Install/Upgrade Bicep
```sh
az bicep install && az bicep upgrade
```

### Manual Deployment Example
#### PowerShell
```powershell
Connect-AzAccount
Select-AzSubscription [Subscription ID]
New-AzSubscriptionDeployment `
  -Confirm `
  -WhatIfResultFormat FullResourcePayloads `
  -Name "core-main" `
  -TemplateFile .\core-main.bicep `
  -Location "North Europe" `
  -Verbose
```
#### Azure CLI
```sh
az login
az account set --subscription {Subscription ID}
az deployment sub create \
  --confirm-with-what-if \
  --result-format FullResourcePayloads \
  --name core-main \
  --template-file .\core-main.bicep \
  --location northeurope \
  --verbose
```

## 🧑‍💻 Portfolio Scenarios
- **Certification Labs:**
  - AZ-700: Network Engineer labs (see `certs/az-700/`)
  - AZ-800: Hybrid Administrator labs (see `certs/az-800/`)
- **Demo Environments:**
  - AVNM (Azure Virtual Network Manager) demo (`demos/avnm/`)
  - Network troubleshooting labs (`demos/network-monitoring-troubleshooting/`)
- **Reusable Modules:**
  - Compute, network, monitoring, security, and more (`modules/`)

## 📖 Documentation
- Each major folder contains a `readme.md` with usage and deployment instructions.
- See individual module and demo folders for details and examples.

## 🤝 Contributing
Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md).

## 📄 License
This project is licensed under the MIT License. See [LICENSE](LICENSE).

---

_Created and maintained by mbiszczanik_
