# AI Agent Instructions for Bicep Development

You are an AI agent specialized in Azure Bicep development. Follow these instructions when generating or modifying Bicep code:

## 1. File Structure and Organization

### File Structure Order
1. File Header (as above)
Every Bicep file must start with this header:
```bicep
/*
SUMMARY: Brief description of what this file deploys
DESCRIPTION: Detailed explanation of resources and configuration
AUTHOR/S: [Author Name]
VERSION: [Version Number]
*/
```

2. Target Scope Declaration
Every Bicep file must start with this header:
```bicep
/*******************
*   Target Scope   *
*******************/
targetScope = 'subscription'
```

3. Parameters Section
```bicep
/*******************
*    Parameters    *
*******************/
param parBaseName string = 'Ashenvale'
param parEnvironmentPrefix string = 'T'
param parLocationPrefix string = 'WEu'
param parLocation string = deployment().location
param parInstanceNumber string = '01'
```

4. Variables Section
```bicep
/*******************
*    Variables     *
*******************/

/** Resource Groups **/
var varVirtualNetworkResourceGroupName = '${par_Environment_Prefix}-${par_Base_Name}-${par_Location_Prefix}-VNet-RG${par_Instance_Number}'
var varNetworkSecurityGroupResourceGroupName = '${par_Environment_Prefix}-${par_Base_Name}-${par_Location_Prefix}-NSG-RG${par_Instance_Number}'
var varNetworkWatcherResourceGroupName = '${par_Environment_Prefix}-${par_Base_Name}-${par_Location_Prefix}-NetworkWatcher-RG${par_Instance_Number}'
var varKeyVaultResourceGroupName = '${par_Environment_Prefix}-${par_Base_Name}-${par_Location_Prefix}-KV-RG01'
```

5. Resource Deployments Section (existing)
```bicep
/*******************
*    Resources     *
*******************/

/** Existing resources **/
resource resVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: parVirtualNetwork
  scope: resourceGroup(par_Subscription, parVirtualNetworkResourceGroup)
}
```

6. Modules Section (if applicable)
```bicep
/*******************
*      Modules     *
*******************/

module modLogServiceResourceGroup 'resource-group/rg.bicep' = {
  name: varLogServiceResourceGroupName
  params: {
    rgName: varLogServiceResourceGroupName
    location: parLocation
    tags: parTags
  }
}

/** Monitoring **/
module modLogAnalytics 'monitoring/logworkspace.bicep' = {
  scope: resourceGroup(varLogServiceResourceGroupName)
  name: varLogAnalyticsName
  params: {
    LogAnalyticsName: varLogAnalyticsName
    tags: parTags
  }
  dependsOn: [
    modLogServiceResourceGroup
  ]
}

module modApplicationInsights 'monitoring/appins.bicep' = {
  scope: resourceGroup(varLogServiceResourceGroupName)
  name: varAppInsightsName
  params: {
    appInsName: varAppInsightsName
    tags: parTags
    logAnalyticsWorkspaceId: modLogAnalytics.outputs.LogAnalyticsID
  }
}
```

7. Outputs Section
```bicep
/******************
*     Outputs     *
******************/

output devCenterProjectId string = resDevCenterProject.id
```

### Spacing Rules
- Use double line breaks between major sections
- Tab indents set to 2 spaces
- Maintain clear section separators with comments (// PARAMETERS, // VARIABLES, etc.)

## 2. Naming Conventions

### Element Prefixes
- Parameters: `par` (e.g., par_Location)
- Variables: `var` (e.g., var_ResourceGroupName)
- Resources: `res` (e.g., res_StorageAccount)
- Modules: `mod` (e.g., mod_KeyVault)
- Outputs: No prefix required

### Standard Parameter Names
- Always use `parLocation` for Azure region parameters
- Exception: Only deviate when services lack region parity

## 3. Code Style Requirements

### General Styling
- Use camelCase for all element names
- Store conditional and loop expressions in variables
- Provide default values for parameters whenever possible
- Document default values in parameter descriptions

### Comments and Documentation
- Use @description() for all parameters
- Add comments for complex logic
- Include documentation URLs for reference
- Use both single-line (//) and multi-line (/* */) comments as appropriate

### Parameter Decorators
- Use @description() for documentation
- Use @allowed() for value constraints
- Use @secure() only for sensitive inputs
- Never use @secure() for outputs

## 4. Best Practices

### Parameter Handling
- Validate all inputs
- Provide clear error messages
- Document default values
- Use secure parameters for sensitive data

### Resource Configuration
- Use latest API versions
- Implement proper dependencies
- Avoid unnecessary dependsOn
- Use symbolic names for references

### Security Considerations
- Never output secure values
- Protect command execution secrets
- Use stable VM images
- Avoid hardcoded credentials

## 5. Module Development

### Module Structure
- Create new folder: `/modules/moduleName`
- Include:
  - README.md with module documentation
  - bicepconfig.json with linting rules
  - Module file and parameters file
  - Media folder for images

### Required Files
- Module implementation (.bicep)
- Parameter file with defaults
- README.md with:
  - Module purpose
  - Parameter documentation
  - Usage examples
  - Bicep visualizer image

## 6. Linting Rules

Enforce these rules via bicepconfig.json:
- No hardcoded environment URLs
- No unnecessary dependencies
- No unused parameters/variables
- Proper secure parameter handling
- No hardcoded locations
- Output count limits
- Parameter count limits
- Resource count limits
- Variable count limits

## 7. Pipeline Integration

Support these deployment stages:
- Build
- Validation
- Deployment
- Each with appropriate parameter handling

## 8. Code Validation Checklist

Before submitting code, verify:
- [ ] Correct file structure
- [ ] Proper naming conventions
- [ ] Parameter validation
- [ ] Security considerations
- [ ] Documentation completeness
- [ ] Linting compliance
- [ ] No hardcoded values
- [ ] Proper error handling

## 9. Target Scope Handling

Support these scopes appropriately:
- tenant
- managementGroup
- subscription
- resourceGroup

Declare scope explicitly using targetScope = '<scope>'

## 10. Resource Tagging

Always include these tags:
- Environment
- Application/Service name
- Owner
- Cost Center (when applicable)
- Project-specific tags as required