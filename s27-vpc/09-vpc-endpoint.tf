data "aws_iam_policy_document" "ec2_assume_s3_ro_policy_document" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "demo_ec2_s3_read_only_role" {
  name               = "DemoRoleEC2-S3ReadOnly"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_s3_ro_policy_document.json
}

resource "aws_iam_role_policy_attachment" "demo_ec2_s3_read_only_role__s3_read_only_access" {
  role       = aws_iam_role.demo_ec2_s3_read_only_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "demo_ec2_s3_read_only_instance_profile" {
  name = "DemoEC2-S3ReadOnlyInstanceProfile"
  role = aws_iam_role.demo_ec2_s3_read_only_role.name
}


resource "aws_vpc_endpoint" "demo_s3_vpc_endpoint" {
  vpc_id            = aws_vpc.demo_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "Demo S3 VPC Endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "demo_s3_vpc_endpoint__private_route_table" {
  route_table_id  = aws_route_table.private_rt.id
  vpc_endpoint_id = aws_vpc_endpoint.demo_s3_vpc_endpoint.id
}

# Delete the NAT Gateway Route from the PrivateRouteTable to see this in action.
# curl example.com -- Times out!
# aws s3 ls --region <region> -- Works!
# re-apply to get the NAT Gateway Route back