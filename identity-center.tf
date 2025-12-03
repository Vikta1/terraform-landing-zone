# identity-center.tf
# AWS IAM Identity Center (formerly AWS SSO) configuration

variable "sso_instance_arn" {
  type        = string
  description = "ARN of the IAM Identity Center (SSO) instance"
}

variable "identity_store_id" {
  type        = string
  description = "Identity Store ID associated with IAM Identity Center"
}

variable "security_admin_group_id" {
  type        = string
  description = "Group ID in the identity store for the Security Admins group"
}

variable "developer_group_id" {
  type        = string
  description = "Group ID in the identity store for the Developers group"
}

variable "readonly_group_id" {
  type        = string
  description = "Group ID in the identity store for ReadOnly users group"
}

# ---------------------------------------------------------
# Permission Sets
# ---------------------------------------------------------

resource "aws_ssoadmin_permission_set" "security_admin" {
  name             = "SecurityAdmin"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT8H"

  tags = local.common_tags
}

resource "aws_ssoadmin_permission_set" "developer" {
  name             = "Developer"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT8H"

  tags = local.common_tags
}

resource "aws_ssoadmin_permission_set" "readonly" {
  name             = "ReadOnly"
  instance_arn     = var.sso_instance_arn
  session_duration = "PT8H"

  tags = local.common_tags
}

# ---------------------------------------------------------
# Permission Set Policies (inline JSON)
# ---------------------------------------------------------

resource "aws_ssoadmin_managed_policy_attachment" "security_admin_adminaccess" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "developer_poweruser" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "readonly_viewonly" {
  instance_arn       = var.sso_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn
}

# ---------------------------------------------------------
# Account Assignments
# ---------------------------------------------------------
# PrincipalType is GROUP – using Identity Center groups

# Security Admins → Security + Logging + Prod
resource "aws_ssoadmin_account_assignment" "security_admin_security" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn

  principal_id   = var.security_admin_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.security.id
}

resource "aws_ssoadmin_account_assignment" "security_admin_logging" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn

  principal_id   = var.security_admin_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.logging.id
}

resource "aws_ssoadmin_account_assignment" "security_admin_prod" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.security_admin.arn

  principal_id   = var.security_admin_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.prod.id
}

# Developers → Dev + Sandbox
resource "aws_ssoadmin_account_assignment" "developer_dev" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn

  principal_id   = var.developer_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.dev.id
}

resource "aws_ssoadmin_account_assignment" "developer_sandbox" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer.arn

  principal_id   = var.developer_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.sandbox.id
}

# ReadOnly → All accounts
resource "aws_ssoadmin_account_assignment" "readonly_security" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.security.id
}

resource "aws_ssoadmin_account_assignment" "readonly_logging" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.logging.id
}

resource "aws_ssoadmin_account_assignment" "readonly_shared_services" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.shared_services.id
}

resource "aws_ssoadmin_account_assignment" "readonly_dev" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.dev.id
}

resource "aws_ssoadmin_account_assignment" "readonly_prod" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.prod.id
}

resource "aws_ssoadmin_account_assignment" "readonly_sandbox" {
  instance_arn       = var.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.readonly.arn

  principal_id   = var.readonly_group_id
  principal_type = "GROUP"

  target_type = "AWS_ACCOUNT"
  target_id   = aws_organizations_account.sandbox.id
}
