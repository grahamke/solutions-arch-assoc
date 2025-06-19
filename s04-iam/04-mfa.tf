# 1. You will need to manually set the mfa device up. Name the device: "device-for-${var.iam_user_name}".
# If the user name is "saac03, then the device name will be "device-for-saac03"
resource aws_iam_virtual_mfa_device mfa {
  virtual_mfa_device_name = "device-for-${var.iam_user_name}"
}

# 2. Once created, you can uncomment the following and import the virtual device
# into the terraform stack with the code below.

# data "aws_caller_identity" "current" {}
#
# import {
#   to = aws_iam_virtual_mfa_device.mfa
#   id = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/device-for-${var.iam_user_name}"
# }
