# Module: Monitor

Reusable Bicep modules for Azure monitoring resources.

## Modules
- `logAnalyticsWorkspace.bicep` — Log Analytics Workspace
- `actionGroup.bicep` — Action Group
- `metricAlert.bicep` — Metric Alert

## Usage Example
```bicep
module logAnalytics 'logAnalyticsWorkspace.bicep' = {
  name: 'logAnalytics'
  params: {
    // ...parameters...
  }
}
```

See each module file for input parameters and outputs.
