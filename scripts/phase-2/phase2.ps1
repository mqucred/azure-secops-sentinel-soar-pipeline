1. PowerShell Script: Check Defender for Cloud CSPM Plan State
Used to verify that the subscription is running the Free / Foundational CSPM tier to ensure no unexpected charges:

PowerShell
# Set Context to Platform Subscription
Set-AzContext -SubscriptionName "sub-ent-platform-prod"

# Query Defender for Cloud Pricing Tiers across all resource types
Get-AzSecurityPricing | Select-Object Name, PricingTier



5. PowerShell Script: Simulate Security Event (Trigger Test Incident)
Used to fire a benign administrative modification on sub-ent-platform-prod to force the KQL Analytic Rule to match and trigger the run-incident-responder Automation Rule:

PowerShell
# Update Resource Group Tags to trigger the 'Microsoft.Resources/subscriptions/write' KQL rule
$Tags = @{
    Environment = "Production"
    Workload    = "SecOps-SIEM"
    ManagedBy   = "Cloud-Ops"
    CostCenter  = "Security"
    LastTested  = (Get-Date).ToString("yyyy-MM-dd-HHmm")
}

Update-AzResourceGroup -Name "rg-secops-prod-01" -Tag $Tags