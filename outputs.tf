output "mgmt_group_user_ids" {
  value = data.aws_identitystore_user.sso_user[*].user_id
}

output "mgmt_idstore_group_id" {
  value = aws_identitystore_group.id_store_group.id
}

output "mgmt_idstore_group_group_id" {
  value = aws_identitystore_group.id_store_group.group_id
}
