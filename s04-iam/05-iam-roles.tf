resource "aws_iam_role" "demo_role_for_ec2" {
  name               = "DemoRoleForEC2"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc.json
}

data "aws_iam_policy_document" "assume_role_policy_doc" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "demo_role_iam_read_only" {
  role       = aws_iam_role.demo_role_for_ec2.name
  policy_arn = data.aws_iam_policy.iam_read_only_policy.arn
}