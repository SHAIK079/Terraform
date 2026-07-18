    output "user_name" {
  value = aws_iam_user.ec2_user
}

output "group_name" {
  value = aws_iam_group.my_group
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "instance_profile" {
  value = aws_iam_instance_profile.profile.name
}