# account.tf
# AWS Organizations: member accounts for the landing zone

# -------------------------------------------------------------------
# Account emails (must be unique per AWS account)
# -------------------------------------------------------------------

variable "security_account_email" {
  type        = string
  description = "Email address for the Security/Audit AWS account"
}

variable "logging_account_email" {
  type        = string
  description = "Email address for the central Logging AWS account"
}

variable "shared_services_account_email" {
  type        = string
  description = "Email address for the Shared Services AWS account"
}

variable "dev_account_email" {
  type        = string
  description = "Email address for the Dev AWS account"
}

variable "prod_account_email" {
  type        = string
  description = "Email address for the Prod AWS account"
}

variable "sandbox_account_email" {
  type        = string
  description = "Email address for the Sandbox AWS account"
}

# Optional: common role name created in new accounts
variable "member_account_role_name" {
  type        = string
  description = "IAM role name to create in new member accounts (for admin access from management account)"
  default     = "OrganizationAccountAccessRole"
}

# -------------------------------------------------------------------
# Member accounts in each OU
# -------------------------------------------------------------------

# Security / Audit account
resource "aws_organizations_account" "security" {
  name                       = "${var.project_name}-security-${var.environment}"
  email                      = var.security_account_email
  parent_id                  = aws_organizations_organizational_unit.security.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}

# Central logging account
resource "aws_organizations_account" "logging" {
  name                       = "${var.project_name}-logging-${var.environment}"
  email                      = var.logging_account_email
  parent_id                  = aws_organizations_organizational_unit.infrastructure.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}

# Shared services account (DNS, directory, tooling, etc.)
resource "aws_organizations_account" "shared_services" {
  name                       = "${var.project_name}-shared-services-${var.environment}"
  email                      = var.shared_services_account_email
  parent_id                  = aws_organizations_organizational_unit.infrastructure.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}

# Dev workloads account
resource "aws_organizations_account" "dev" {
  name                       = "${var.project_name}-dev-${var.environment}"
  email                      = var.dev_account_email
  parent_id                  = aws_organizations_organizational_unit.workloads.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}

# Prod workloads account
resource "aws_organizations_account" "prod" {
  name                       = "${var.project_name}-prod-${var.environment}"
  email                      = var.prod_account_email
  parent_id                  = aws_organizations_organizational_unit.workloads.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}

# Sandbox / experimentation account
resource "aws_organizations_account" "sandbox" {
  name                       = "${var.project_name}-sandbox-${var.environment}"
  email                      = var.sandbox_account_email
  parent_id                  = aws_organizations_organizational_unit.sandbox.id
  role_name                  = var.member_account_role_name
  iam_user_access_to_billing = "DENY"

  tags = local.common_tags
}
