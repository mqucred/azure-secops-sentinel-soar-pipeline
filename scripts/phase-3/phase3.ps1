1. PowerShell Script: ARM REST API Bypass (Querying Sentinel Alert Rules)
Used to communicate directly with the Azure ARM backend provider to bypass portal UI anomalies and verify active analytic rules:

PowerShell
# Set context to the platform subscription
Set-AzContext -SubscriptionName "sub-ent-platform-prod"

# Define variables for workspace and resource group
$ResourceGroup = "rg-secops-prod-01"
$WorkspaceName = "law-secops-prod-01"
$SubscriptionId = (Get-AzContext).Subscription.Id




PowerShell
# Update tags on a test resource group to fire control plane activity logs
$Tags = @{
    Environment = "Production"
    Workload    = "SecOps-Validation"
    TestedAt    = (Get-Date).ToString("yyyy-MM-dd-HHmm")
}

Update-AzResourceGroup -Name "rg-secops-prod-01" -Tag $Tags