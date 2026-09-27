2. KQL Validation Query: Checking Log Ingestion & Table Activity
Used to validate that workspace telemetry was flowing correctly prior to rule verification:

Code snippet
AzureActivity
| where TimeGenerated > ago(24h)
| summarize EventCount = count() by CategoryValue, ResourceGroup, ActivityStatusValue
| order by EventCount desc
3. PowerShell Script: Simulating a Resource Deletion Event (To Trigger Custom Rule)
Used to generate test activity that matches the SecOps - Successful Resource Deletion rule criteria: