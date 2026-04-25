# Cloud Least-Privilege IAM Policy Template

A comprehensive collection of Azure Role-Based Access Control (RBAC) policy templates implementing the principle of least privilege. Designed for secure cloud infrastructure management and compliance with SC-900/SC-200 certifications.

## Overview

This project provides production-ready Azure custom role definitions that grant minimal required permissions for various user roles, reducing security risks from over-privileged accounts.

## Included Roles

### 1. Secure Baseline User
**Purpose**: Read-only access for standard users monitoring resources

**Permissions**:
- Read access to storage accounts, VMs, networks
- Access to Key Vault secrets (read-only)
- Read role assignments and resource groups
- Access to SQL databases and web apps (read-only)

**Use Case**: Help desk, auditors, junior admins

### 2. Secure Developer
**Purpose**: Application deployment and management permissions

**Permissions**:
- Full access to web apps and SQL databases
- Read/write storage accounts
- Deployment management
- Read access to VMs and secrets

**Exclusions**:
- No authorization changes
- No network modifications
- No disk deletions

**Use Case**: Developers needing to deploy and maintain applications

## Deployment

### Prerequisites
- Azure PowerShell module (`Install-Module -Name Az`)
- Azure subscription contributor or owner access
- Azure CLI or PowerShell authenticated

### Automated Deployment
```powershell
# Deploy baseline user role
.\deploy_roles.ps1 -RoleFile "secure_baseline_user_role.json" -SubscriptionId "your-sub-id"

# Deploy developer role
.\deploy_roles.ps1 -RoleFile "secure_developer_role.json" -SubscriptionId "your-sub-id"

# WhatIf mode
.\deploy_roles.ps1 -RoleFile "secure_baseline_user_role.json" -WhatIf
```

### Manual Deployment via Portal
1. Go to Azure Portal > Subscriptions > Access Control (IAM)
2. Click "Add" > "Add custom role"
3. Import JSON file
4. Assign to users/groups

## Security Best Practices

### Principle of Least Privilege
- Grant only necessary permissions
- Use custom roles instead of built-in roles
- Regularly review and revoke unnecessary access

### Role Design Guidelines
- Start with minimal permissions
- Add permissions as needed
- Use NotActions to exclude dangerous operations
- Scope roles to specific resource groups when possible

### Monitoring and Auditing
- Enable Azure Activity Logs
- Use Azure Monitor for role usage tracking
- Implement regular access reviews
- Set up alerts for privilege escalation

## Advanced Configurations

### Conditional Access
Integrate with Azure AD Conditional Access policies:
- Require MFA for role assignments
- Geo-location restrictions
- Device compliance checks

### Just-In-Time Access
Use Azure Privileged Identity Management (PIM):
- Time-bound role activations
- Approval workflows for elevated access
- Automated de-escalation

### Multi-Subscription Scenarios
```json
"AssignableScopes": [
  "/subscriptions/sub1",
  "/subscriptions/sub2",
  "/providers/Microsoft.Management/managementGroups/mg1"
]
```

## Compliance Mapping

### SC-900/SC-200 Alignment
- **Identity and Access Management**: Custom roles demonstrate IAM understanding
- **Zero Trust**: Least privilege implementation
- **Security Operations**: Monitoring and auditing capabilities

### Industry Standards
- **NIST CSF**: PR.AC-4 (Access Permissions)
- **ISO 27001**: A.9.2.2 (User Access Provisioning)
- **CIS Controls**: 5.1 (Minimize Administrative Privileges)

## Testing and Validation

### Role Validation Script
```powershell
# Test role permissions
.\tests\validate_roles.ps1 -RoleName "Secure Baseline User"
```

### Permission Testing
- Attempt operations with the role
- Verify denials for unauthorized actions
- Test in non-production subscription

## Troubleshooting

### Common Issues

**Role Assignment Failures**
- Check subscription scope
- Verify user has role assignment permissions
- Ensure role definition is valid JSON

**Permission Denied Errors**
- Review NotActions in role definition
- Check for conflicting deny assignments
- Verify scope includes target resources

**Role Not Appearing**
- Wait for Azure propagation (up to 10 minutes)
- Refresh portal/CLI cache
- Check for syntax errors in JSON

## Files Structure

```
src/
├── secure_baseline_user_role.json    # Basic user role
├── secure_developer_role.json        # Developer role
└── deploy_roles.ps1                  # Deployment script

docs/
└── README.md                         # This documentation

tests/
├── validate_roles.ps1                # Role validation
└── test_scenarios.json               # Test cases
```

## Contributing

1. Follow Azure RBAC best practices
2. Test roles in non-production environment
3. Include security review for new permissions
4. Update documentation

## Resources

- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)
- [Azure Custom Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/custom-roles)
- [Least Privilege Principle](https://en.wikipedia.org/wiki/Principle_of_least_privilege)

This project provides a solid foundation for implementing secure, compliant Azure access management in enterprise environments.