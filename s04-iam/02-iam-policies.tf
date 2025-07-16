# to see this in action, remove the user from the admin group
data "aws_iam_policy" "iam_read_only_policy" {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "iam_read_only_policy" {
  user       = aws_iam_user.iam_user.name
  policy_arn = data.aws_iam_policy.iam_read_only_policy.arn
}

resource "aws_iam_group" "developers" {
  name = "Developers"
}

resource "aws_iam_group_membership" "developers" {
  name  = "developers_group_members"
  users = [aws_iam_user.iam_user.name]
  group = aws_iam_group.developers.name
}

data "aws_iam_policy" "alexa_for_business_policy" {
  arn = "arn:aws:iam::aws:policy/AlexaForBusinessDeviceSetup"
}

resource "aws_iam_group_policy_attachment" "alexa_for_business_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = data.aws_iam_policy.alexa_for_business_policy.arn
}