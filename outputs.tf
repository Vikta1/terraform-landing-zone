# outputs.tf

output "current_account_id" {
  description = "The AWS account ID Terraform is currently using"
  value       = data.aws_caller_identity.current.account_id
}

output "current_iam_arn" {
  description = "The IAM ARN Terraform is using to authenticate"
  value       = data.aws_caller_identity.current.arn
}

output "current_region" {
  description = "The AWS region in use"
  value       = data.aws_region.current.name
}
