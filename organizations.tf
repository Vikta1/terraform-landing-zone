# org.tf
# AWS Organizations: organization + organizational units (OUs)

# Creates or manages the AWS Organization in this management account.
# NOTE: This must be run from the management (root) account.
resource "aws_organizations_organization" "this" {
  feature_set = "ALL"
}

# Local names for OUs, using your project_name + environment for consistency
locals {
  ou_security_name       = "${var.project_name}-security"
  ou_infrastructure_name = "${var.project_name}-infrastructure"
  ou_workloads_name      = "${var.project_name}-workloads"
  ou_sandbox_name        = "${var.project_name}-sandbox"
}

# Security OU – for security/audit account(s)
resource "aws_organizations_organizational_unit" "security" {
  name      = local.ou_security_name
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Infrastructure OU – for logging/shared services/etc.
resource "aws_organizations_organizational_unit" "infrastructure" {
  name      = local.ou_infrastructure_name
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Workloads OU – for app workloads (dev/prod)
resource "aws_organizations_organizational_unit" "workloads" {
  name      = local.ou_workloads_name
  parent_id = aws_organizations_organization.this.roots[0].id
}

# Sandbox OU – for experimentation accounts
resource "aws_organizations_organizational_unit" "sandbox" {
  name      = local.ou_sandbox_name
  parent_id = aws_organizations_organization.this.roots[0].id
}
