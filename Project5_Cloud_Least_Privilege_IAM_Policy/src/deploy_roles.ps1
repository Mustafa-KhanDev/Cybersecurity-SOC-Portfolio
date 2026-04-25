# Azure RBAC Role Deployment Script
# Deploys custom roles to Azure subscription

param(
    [string]$SubscriptionId = "your-subscription-id",
    [string[]]$RoleFiles = @("secure_baseline_user_role.json", "secure_developer_role.json", "secure_auditor_role.json"),
    [switch]$WhatIf
)

# Login to Azure (uncomment if needed)
# Connect-AzAccount

# Set subscription
Set-AzContext -SubscriptionId $SubscriptionId

foreach ($RoleFile in $RoleFiles) {
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
            Write-Host "Failed to deploy role '$($roleDefinition.Name)': $_" -ForegroundColor Red
        }
    }
    Write-Host ""
}

Write-Host "Deployment complete."