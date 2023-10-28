variable "mgmt_group_name" {
  type = string
  validation {
    condition = can(regex("^[A-Za-z]+$", var.mgmt_group_name))
    error_message = "Must Be Alphabetic Only with no spaces"
  }
}

variable "mgmt_group_desc" {
  type = string
  default = "Default Group Description"
}

variable "members_username" {
  type = list(string)
}

variable "iam_policy_document_json" {
  type = string
}

variable "session_duration" {
  type = string
  validation {
    condition = can(regex("^PT\\d+H$", var.session_duration))
    error_message = "Session Duration must match pattern PT*H where * is a numeric string"
  }
}

variable "mgmt_group_account_id" {
  type = string
  description = "AWS Account ID to be assigned to the management group"
}

variable "sso_identity_store_instance_arn" {
  type = string
  description = "AWS SSO Identity Store ARN"
}

variable "sso_identity_store_instance_id" {
  type = string
  description = "AWS SSO Identity Store ID"
}
