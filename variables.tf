variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "terraform-landing-zone"
}

variable "environment" {
  description = "Deployment environment (dev, qa, prod)"
  type        = string
  default     = "dev"
}

variable "management_account_id" {
  type        = string
  description = "AWS Organization management (root) account ID"
}

# Account IDs
variable "security_account_id" {
  type        = string
  description = "AWS account ID of the Security/Audit account"
}

variable "logging_account_id" {
  type        = string
  description = "AWS account ID of the central Logging account"
}

# CloudTrail org trail bucket
variable "org_trail_bucket_name" {
  type        = string
  description = "Name of the S3 bucket (in the logging account) used for the organization-wide CloudTrail trail"
}
