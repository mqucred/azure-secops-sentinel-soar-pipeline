<#
.SYNOPSIS
    Phase 1 Deployment Script: SecOps Control Plane, Sentinel SIEM, FinOps Controls, & SOAR Logic App Playbook.

    Deploys the foundational SecOps infrastructure in East US:
      - Resource Group: rg-secops-prod-01
      - Log Analytics Workspace: law-secops-prod-01 (1 GB/day cap, 30-day retention)

#>

# -----------------------------------------------------------------------------
# 0. Global Parameters & Governance Tags
# -----------------------------------------------------------------------------
$ResourceGroupName = "rg-secops-prod-01"
$WorkspaceName     = "law-secops-prod-01"
$LogicAppName       = "la-secops-incident-responder"
$Location          = "East US"
$SubscriptionName  = "sub-ent-platform-prod"

$Tags = @{
    Environment = "Production"
    Workload    = "SecOps-SIEM"
    ManagedBy   = "Cloud-Ops"
    CostCenter  = "Security"
}

# -----------------------------------------------------------------------------
# 1. Azure Context Setup
# -----------------------------------------------------------------------------
Write-Host "Setting Azure Subscription Context..." -ForegroundColor Cyan
Set-AzContext -SubscriptionName $SubscriptionName

# -----------------------------------------------------------------------------
# 2. Provision Centralized Resource Group
# -----------------------------------------------------------------------------
Write-Host "Creating Resource Group: $ResourceGroupName..." -ForegroundColor Cyan
New-AzResourceGroup `
    -Name $ResourceGroupName `
    -Location $Location `
    -Tag $Tags `
    -Force

# -----------------------------------------------------------------------------
# 3. Provision Log Analytics Workspace (FinOps 30-Day Retention)
# -----------------------------------------------------------------------------
Write-Host "Deploying Log Analytics Workspace: $WorkspaceName..." -ForegroundColor Cyan
New-AzOperationalInsightsWorkspace `
    -ResourceGroupName $ResourceGroupName `
    -Name $WorkspaceName `
    -Location $Location `
    -Sku "pergb2018" `
    -RetentionInDays 30 `
    -Tag $Tags

# -----------------------------------------------------------------------------
# 4. Onboard Microsoft Sentinel Solution
# -----------------------------------------------------------------------------
Write-Host "Onboarding Microsoft Sentinel to $WorkspaceName..." -ForegroundColor Cyan
New-AzOperationalInsightsIntelligencePack `
    -ResourceGroupName $ResourceGroupName `
    -WorkspaceName $WorkspaceName `
    -IntelligencePackName "SecurityInsights" `
    -Enabled $true

# -----------------------------------------------------------------------------
# 5. Enforce FinOps Daily Ingestion Guardrail (1 GB/day)
# -----------------------------------------------------------------------------
Write-Host "Applying Daily Ingestion Cap (1 GB/Day) to $WorkspaceName..." -ForegroundColor Cyan
Set-AzOperationalInsightsWorkspace `
    -ResourceGroupName $ResourceGroupName `
    -Name $WorkspaceName `
    -DailyQuotaGb 1
