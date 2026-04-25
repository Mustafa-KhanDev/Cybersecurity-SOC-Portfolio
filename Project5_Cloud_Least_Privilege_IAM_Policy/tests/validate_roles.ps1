# Role Validation Script
# Validates Azure custom role definitions

param(
    [string]$RoleFile = "..\src\secure_baseline_user_role.json"
)

Write-Host "Validating Azure RBAC Role Definition..."
Write-Host "=" * 50

# Check if file exists
if (Test-Path $RoleFile) {
    Write-Host "✓ Role file found: $RoleFile"
} else {
    Write-Host "✗ Role file not found: $RoleFile"
    exit 1
}

# Validate JSON syntax
try {
    $roleDefinition = Get-Content $RoleFile | ConvertFrom-Json
    Write-Host "✓ Valid JSON syntax"
} catch {
    Write-Host "✗ Invalid JSON syntax: $_"
    exit 1
}

# Validate required fields
$requiredFields = @("Name", "IsCustom", "Description", "Actions", "NotActions", "AssignableScopes")
$missingFields = @()

foreach ($field in $requiredFields) {
    if (-not $roleDefinition.PSObject.Properties.Name.Contains($field)) {
        $missingFields += $field
    }
}

if ($missingFields.Count -eq 0) {
    Write-Host "✓ All required fields present"
} else {
    Write-Host "✗ Missing required fields: $($missingFields -join ', ')"
}

# Validate Actions array
if ($roleDefinition.Actions -is [array]) {
    Write-Host "✓ Actions is valid array with $($roleDefinition.Actions.Count) permissions"
} else {
    Write-Host "✗ Actions is not a valid array"
}

# Validate AssignableScopes
if ($roleDefinition.AssignableScopes -is [array] -and $roleDefinition.AssignableScopes.Count -gt 0) {
    Write-Host "✓ AssignableScopes is valid array"
} else {
    Write-Host "✗ AssignableScopes is not valid"
}

# Check for common security issues
$dangerousPermissions = @(
    "*/write",
    "*/delete",
    "Microsoft.Authorization/*/write",
    "Microsoft.Network/*/write"
)

$foundDangerous = @()
foreach ($action in $roleDefinition.Actions) {
    foreach ($dangerous in $dangerousPermissions) {
        if ($action -like $dangerous) {
            $foundDangerous += $action
        }
    }
}

if ($foundDangerous.Count -eq 0) {
    Write-Host "✓ No dangerous permissions found"
} else {
    Write-Host "⚠ Potentially dangerous permissions: $($foundDangerous -join ', ')"
}

Write-Host "Validation complete."