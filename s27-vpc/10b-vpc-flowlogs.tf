data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "athena_bucket" {
  bucket = "${var.s3_flow_logs_bucket_name}-athena"

  force_destroy = true
}

resource "aws_athena_workgroup" "flow_logs" {
  name = "flow_logs_workgroup"
  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true
    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_bucket.bucket}/query-results"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  force_destroy = true

  tags = var.common_tags
}

resource "aws_athena_database" "flow_logs" {
  name          = "vpc_flow_logs"
  bucket        = aws_s3_bucket.athena_bucket.bucket
  force_destroy = true
}

resource "aws_athena_named_query" "flow_logs_table" {
  name      = "create_flow_logs_table"
  workgroup = aws_athena_workgroup.flow_logs.name
  database  = aws_athena_database.flow_logs.name
  query     = <<EOF
    CREATE EXTERNAL TABLE IF NOT EXISTS vpc_flow_logs (
      version int,
      account_id string,
      interface_id string,
      srcaddr string,
      dstaddr string,
      srcport int,
      dstport int,
      protocol bigint,
      packets bigint,
      bytes bigint,
      start bigint,
      `end` bigint,
      action string,
      log_status string,
      vpc_id string,
      subnet_id string,
      instance_id string,
      tcp_flags int,
      type string,
      pkt_srcaddr string,
      pkt_dstaddr string,
      region string,
      az_id string,
      sublocation_type string,
      sublocation_id string,
      pkt_src_aws_service string,
      pkt_dst_aws_service string,
      flow_direction string,
      traffic_path int
    )
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ' '
    LOCATION 's3://${aws_s3_bucket.flow_logs_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/vpcflowlogs/${data.aws_region.current.region}/'
    TBLPROPERTIES
    (
      'skip.header.line.count'='1'
    );
    EOF
}

# After applying this, you can:
# Go to the Athena console
# Select the flow_logs_workgroup
# Run the saved query to create the table
# Start querying your VPC Flow Logs
# Example query to test it:
# SELECT *
# FROM vpc_flow_logs
# LIMIT 10;
