# This is copied from the earlier s04-iam.
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

##########################################################################################
# IMPORTANT!
# Uncomment the following lines to attach the IAM policy to the IAM role for the EC2 Instance Roles Demo.
# When commenting out the iam_instance_profile on the aws_instance resource, terraform
# will not update the instance to remove the profile.
# True as of terraform v1.12.2; aws v5.98.0
##########################################################################################

# resource aws_iam_role_policy_attachment demo_role_iam_read_only {
#   role = aws_iam_role.demo_role_for_ec2.name
#   policy_arn = data.aws_iam_policy.iam_read_only_policy.arn
# }

data "aws_iam_policy" "iam_read_only_policy" {
  arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_hands_on_profile" {
  name = "ec2_handson_profile"
  role = aws_iam_role.demo_role_for_ec2.name
}