

// URI https://learn.microsoft.com/en-us/azure/templates/microsoft.web/sites/config-logs?pivots=deployment-language-bicep

param par_AppService_Name string
@description('Kind of resource. e.g. app,linux; app,windows')
param par_AppService_Kind string
@description('Retention in days. Remove files older than X days. 0 or lower means no retention.')
param par_AppServiceLogs_RetentionDays int
@description('	Maximum size in megabytes that http log files can use. When reached old log files will be removed to make space for new ones. Value can range between 25 and 100.')
param par_AppServiceLogs_RetentionMB int

resource res_AppServiceLogs_Config 'Microsoft.Web/sites/config@2022-09-01' = {
  name: '${par_AppService_Name}/logs'
  kind: par_AppService_Kind
  properties: {
    httpLogs: {
      fileSystem: {
        enabled: true
        retentionInDays: par_AppServiceLogs_RetentionDays
        retentionInMb: par_AppServiceLogs_RetentionMB
      }
    }
  }
}

