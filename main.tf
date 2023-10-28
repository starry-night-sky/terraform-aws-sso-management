resource "aws_ssoadmin_permission_set" "permission_set" {
  name = var.mgmt_group_name
  description = var.mgmt_group_desc
  instance_arn = var.sso_identity_store_instance_arn
  session_duration = var.session_duration
}

resource "aws_ssoadmin_permission_set_inline_policy" "power_user_permission_set_policy" {
  inline_policy      = var.iam_policy_document_json
  instance_arn       = var.sso_identity_store_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn
}

data "aws_identitystore_user" "sso_user" {
  identity_store_id = var.sso_identity_store_instance_id
  count = length(var.members_username)

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = element(var.members_username, count.index)
    }
  }
}

resource "aws_identitystore_group" "id_store_group" {
  identity_store_id = var.sso_identity_store_instance_id
  display_name      = local.sso_group_name
  description       = "Group ${local.sso_group_name}"
}

resource "aws_identitystore_group_membership" "user_group_membership" {
  count = length(var.members_username)
  identity_store_id = var.sso_identity_store_instance_id
  group_id          = aws_identitystore_group.id_store_group.group_id
  member_id         = element(data.aws_identitystore_user.sso_user[*].user_id, count.index)
}

resource "aws_ssoadmin_account_assignment" "sysadmin-user-account-assignment" {
  instance_arn       = var.sso_identity_store_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.permission_set.arn

  principal_id   = aws_identitystore_group.id_store_group.group_id
  principal_type = "GROUP"

  target_id   = var.mgmt_group_account_id
  target_type = "AWS_ACCOUNT"
}
