# scp.tf
# Service Control Policies (SCPs) for AWS Landing Zone

# ---------------------------------------------------------
# SCP 1: Deny disabling or deleting critical security services
# ---------------------------------------------------------

resource "aws_organizations_policy" "deny_security_services_disable" {
  name        = "${var.project_name}-deny-security-services-${var.environment}"
  description = "Deny disabling GuardDuty, SecurityHub, CloudTrail, or Config"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyDisableSecurityServices"
        Effect = "Deny"
        Action = [
          "guardduty:DeleteDetector",
          "guardduty:UpdateDetector",
          "guardduty:StopMonitoringMembers",
          "securityhub:DisableSecurityHub",
          "config:StopConfigurationRecorder",
          "cloudtrail:StopLogging",
          "cloudtrail:DeleteTrail"
        ]
        Resource = "*"
      }
    ]
  })

  type = "SERVICE_CONTROL_POLICY"
}

# Attach to all organizational units
resource "aws_organizations_policy_attachment" "deny_security_services_to_security" {
  policy_id = aws_organizations_policy.deny_security_services_disable.id
  target_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_policy_attachment" "deny_security_services_to_infrastructure" {
  policy_id = aws_organizations_policy.deny_security_services_disable.id
  target_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_policy_attachment" "deny_security_services_to_workloads" {
  policy_id = aws_organizations_policy.deny_security_services_disable.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_policy_attachment" "deny_security_services_to_sandbox" {
  policy_id = aws_organizations_policy.deny_security_services_disable.id
  target_id = aws_organizations_organizational_unit.sandbox.id
}

# ---------------------------------------------------------
# SCP 2: Deny use of non-approved AWS regions
# Example: Allow only us-east-1 and us-west-2
# ---------------------------------------------------------

resource "aws_organizations_policy" "deny_unapproved_regions" {
  name        = "${var.project_name}-deny-unapproved-regions-${var.environment}"
  description = "Deny all AWS regions except approved ones"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnapprovedRegions"
        Effect = "Deny"
        NotAction = [
          "globalaccelerator:*",
          "iam:*",
          "organizations:*",
          "route53:*",
          "s3:*"
        ]
        Resource = "*"
        Condition = {
          "StringNotEquals" = {
            "aws:RequestedRegion" = [
              "us-east-1",
              "us-west-2"
            ]
          }
        }
      }
    ]
  })

  type = "SERVICE_CONTROL_POLICY"
}

# Attach region restriction SCP to all OUs
resource "aws_organizations_policy_attachment" "deny_regions_to_security" {
  policy_id = aws_organizations_policy.deny_unapproved_regions.id
  target_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_policy_attachment" "deny_regions_to_infrastructure" {
  policy_id = aws_organizations_policy.deny_unapproved_regions.id
  target_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_policy_attachment" "deny_regions_to_workloads" {
  policy_id = aws_organizations_policy.deny_unapproved_regions.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_policy_attachment" "deny_regions_to_sandbox" {
  policy_id = aws_organizations_policy.deny_unapproved_regions.id
  target_id = aws_organizations_organizational_unit.sandbox.id
}

# ---------------------------------------------------------
# SCP 3: Deny IAM wildcard permissions (least privilege enforcement)
# ---------------------------------------------------------

resource "aws_organizations_policy" "deny_iam_wildcards" {
  name        = "${var.project_name}-deny-iam-wildcards-${var.environment}"
  description = "Deny IAM actions with '*' wildcard to enforce least privilege"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyIAMStarPermissions"
        Effect = "Deny"
        Action = [
          "iam:CreatePolicyVersion",
          "iam:PutGroupPolicy",
          "iam:PutRolePolicy",
          "iam:PutUserPolicy"
        ]
        Resource = "*"
        Condition = {
          "StringLike" = {
            "iam:PolicyDocument" = "*\"Action\":\"*:*\"*"
          }
        }
      }
    ]
  })

  type = "SERVICE_CONTROL_POLICY"
}

# Attach IAM wildcard SCP to all OUs
resource "aws_organizations_policy_attachment" "deny_iam_wildcards_to_security" {
  policy_id = aws_organizations_policy.deny_iam_wildcards.id
  target_id = aws_organizations_organizational_unit.security.id
}

resource "aws_organizations_policy_attachment" "deny_iam_wildcards_to_infrastructure" {
  policy_id = aws_organizations_policy.deny_iam_wildcards.id
  target_id = aws_organizations_organizational_unit.infrastructure.id
}

resource "aws_organizations_policy_attachment" "deny_iam_wildcards_to_workloads" {
  policy_id = aws_organizations_policy.deny_iam_wildcards.id
  target_id = aws_organizations_organizational_unit.workloads.id
}

resource "aws_organizations_policy_attachment" "deny_iam_wildcards_to_sandbox" {
  policy_id = aws_organizations_policy.deny_iam_wildcards.id
  target_id = aws_organizations_organizational_unit.sandbox.id
}
