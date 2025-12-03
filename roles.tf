

# -------------------------------------------------------------------
# Organization Audit Role – assumed by Security account
# -------------------------------------------------------------------

resource "aws_iam_role" "org_audit_role" {
  name = "${local.name_prefix}-org-audit-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSecurityAccountAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.security_account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_policy" "org_audit_policy" {
  name        = "${local.name_prefix}-org-audit-policy"
  description = "Read-only permissions across the organization for security/audit purposes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadOnlyAll"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "rds:Describe*",
          "s3:Get*",
          "s3:List*",
          "iam:Get*",
          "iam:List*",
          "logs:Describe*",
          "logs:Get*",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus",
          "config:Describe*",
          "config:Get*",
          "guardduty:List*",
          "guardduty:Get*",
          "securityhub:Get*",
          "securityhub:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "org_audit_attach" {
  role       = aws_iam_role.org_audit_role.name
  policy_arn = aws_iam_policy.org_audit_policy.arn
}

# -------------------------------------------------------------------
# Organization Logging Role – assumed by Logging account
# -------------------------------------------------------------------

resource "aws_iam_role" "org_logging_role" {
  name = "${local.name_prefix}-org-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLoggingAccountAssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.logging_account_id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_policy" "org_logging_policy" {
  name        = "${local.name_prefix}-org-logging-policy"
  description = "Permissions to write logs and access log-related resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowWriteToLogBuckets"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowCloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "org_logging_attach" {
  role       = aws_iam_role.org_logging_role.name
  policy_arn = aws_iam_policy.org_logging_policy.arn
}
