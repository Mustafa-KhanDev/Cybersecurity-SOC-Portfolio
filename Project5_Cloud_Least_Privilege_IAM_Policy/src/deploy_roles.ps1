# Azure RBAC Role Deployment Script
# Deploys custom roles to Azure subscription

param(
    [string]$SubscriptionId = "your-subscription-id",
    [string]$RoleFile = "secure_baseline_user_role.json",
    [switch]$WhatIf
)

# Login to Azure (uncomment if needed)
# Connect-AzAccount

# Set subscription
Set-AzContext -SubscriptionId $SubscriptionId

Write-Host "Deploying Azure RBAC Role: $RoleFile"

# Read role definition
$roleDefinition = Get-Content $RoleFile | ConvertFrom-Json

# Check if role already exists
$existingRole = Get-AzRoleDefinition -Name $roleDefinition.Name -ErrorAction SilentlyContinue

if ($existingRole) {
    Write-Host "Role '$($roleDefinition.Name)' already exists. Updating..."
    $roleDefinition.Id = $existingRole.Id
} else {
    Write-Host "Creating new role '$($roleDefinition.Name)'..."
}

# Deploy role
if ($WhatIf) {
    Write-Host "WhatIf: Would deploy role $($roleDefinition.Name)"
} else {
    try {
        New-AzRoleDefinition -Role $roleDefinition
        Write-Host "Role '$($roleDefinition.Name)' deployed successfully."
    } catch {
        Write-Host "Failed to deploy role: $_" -ForegroundColor Red
    }
}

Write-Host "Deployment complete."