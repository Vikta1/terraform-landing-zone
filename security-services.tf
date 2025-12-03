
# -------------------------------------------------------------------
# GuardDuty – delegated admin at organization level
# -------------------------------------------------------------------

resource "aws_guardduty_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

# -------------------------------------------------------------------
# Security Hub – delegated admin at organization level
# -------------------------------------------------------------------

resource "aws_securityhub_organization_admin_account" "this" {
  admin_account_id = var.security_account_id
}

# -------------------------------------------------------------------
# Organization-wide CloudTrail
# -------------------------------------------------------------------

resource "aws_cloudtrail" "org_trail" {
  name                          = "${var.project_name}-org-trail-${var.environment}"
  s3_bucket_name                = var.org_trail_bucket_name
  include_global_service_events = true
  is_multi_region_trail         = true
  is_organization_trail         = true
  enable_log_file_validation    = true

  tags = local.common_tags
}
