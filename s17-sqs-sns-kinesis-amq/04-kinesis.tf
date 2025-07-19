resource "aws_kinesis_stream" "demo" {
  name = "DemoStream"

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  shard_count         = 1
  retention_period    = 24
  encryption_type     = "NONE"
  shard_level_metrics = []
}

resource "aws_kinesis_firehose_delivery_stream" "demo" {
  name        = "DemoDeliveryStream"
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.demo.arn
    role_arn           = aws_iam_role.kinesis_datastream_role.arn
  }

  extended_s3_configuration {
    bucket_arn         = aws_s3_bucket.firehose_bucket.arn
    role_arn           = aws_iam_role.kinesis_firehose_service_role.arn
    buffering_size     = 1
    buffering_interval = 60
  }
}

resource "aws_s3_bucket" "firehose_bucket" {
  bucket = var.firehose_bucket_name
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "firehose_s3_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.firehose_bucket.arn,
      "${aws_s3_bucket.firehose_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_role" "kinesis_firehose_service_role" {
  name               = "kinesis_firehose_service_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name   = "firehose_s3_policy"
  role   = aws_iam_role.kinesis_firehose_service_role.id
  policy = data.aws_iam_policy_document.firehose_s3_policy.json
}

resource "aws_iam_role" "kinesis_datastream_role" {
  name               = "kinesis_data_stream_role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_kinesis_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards"
    ]
    resources = [
      aws_kinesis_stream.demo.arn
    ]
  }
}

resource "aws_iam_role_policy" "firehose_kinesis_policy" {
  name   = "firehose_kinesis_policy"
  role   = aws_iam_role.kinesis_datastream_role.id
  policy = data.aws_iam_policy_document.firehose_kinesis_policy.json
}