# Create an IAM user with admin access via group membership

resource aws_iam_user iam_user {
  name = var.iam_user_name
}

resource "aws_iam_user_login_profile" "login_profile" {
  user                    = aws_iam_user.iam_user.name
  password_length = 20
  password_reset_required = true
}

output "iam_user_password" {
  value     = aws_iam_user_login_profile.login_profile.password
  sensitive = true
}

resource aws_iam_group admin_group {
  name = "saac03-admin"
}

resource aws_iam_group_membership admin_group_membership {
  name = "admin_group_membership"
  users = [
    aws_iam_user.iam_user.name
  ]
  group = aws_iam_group.admin_group.name
}

data aws_iam_policy admin_policy {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource aws_iam_group_policy_attachment admin_policy_attachment {
  group = aws_iam_group.admin_group.name
  policy_arn = data.aws_iam_policy.admin_policy.arn
}

# Create an account alias for easier login to the console

# Uncomment this section and set your own globally unique alias for your account.
# resource "aws_iam_account_alias" "account_alias" {
#   account_alias = "solutions-arch-assoc"  # Must be unique across all AWS accounts
# }
#
# # Optional: Output the sign-in URL
# output "signin_url" {
#   value = "https://${aws_iam_account_alias.account_alias.account_alias}.signin.aws.amazon.com/console"
# }
