resource "aws_flow_log" "demo_s3_flow_log" {
  log_destination          = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type     = "s3"
  traffic_type             = "ALL"
  max_aggregation_interval = var.flow_logs_aggregation_interval
  vpc_id                   = aws_vpc.demo_vpc.id

  tags = merge(var.common_tags, {
    Name = "DemoFlowS3Logs"
  })
}

resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = var.s3_flow_logs_bucket_name

  force_destroy = true
}

data "aws_iam_policy_document" "flow_logs_bucket_policy_document" {
  version = "2012-10-17"
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.flow_logs_bucket.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.flow_logs_bucket.arn]
  }
}

resource "aws_s3_bucket_policy" "flow_logs_bucket_policy" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  policy = data.aws_iam_policy_document.flow_logs_bucket_policy_document.json
}

resource "aws_flow_log" "demo_cw_flow_log" {
  traffic_type             = "ALL"
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.vpc_flow_logs_cw_log_group.arn
  iam_role_arn             = aws_iam_role.vpc_flow_logs_cw_role.arn
  max_aggregation_interval = var.flow_logs_aggregation_interval
  vpc_id                   = aws_vpc.demo_vpc.id

  tags = merge(var.common_tags, {
    Name = "DemoFlowLogCWLogs"
  })
}

data "aws_iam_policy_document" "vpc_flow_logs_assume_role_policy_document" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc_flow_logs_cw_role" {
  name               = "myFlowlogsRole"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role_policy_document.json
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs_cw_role_policy_attachment" {
  role       = aws_iam_role.vpc_flow_logs_cw_role.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs_cw_log_group" {
  name              = "VPCFlowLogs"
  retention_in_days = 1
}