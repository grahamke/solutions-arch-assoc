resource "aws_s3_bucket" "origin" {
  bucket = var.bucket_origin
}

resource "aws_s3_bucket_versioning" "origin" {
  bucket = aws_s3_bucket.origin.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "replica" {
  region = var.replication_region
  bucket = var.bucket_destination
}

resource "aws_s3_bucket_versioning" "replica" {
  region = var.replication_region
  bucket = aws_s3_bucket.replica.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "beach_not_replicated" {
  bucket = aws_s3_bucket.origin.bucket
  key    = "beach.jpg"
  source = "../resources/beach.jpg"
}

resource "aws_s3_bucket_replication_configuration" "demo" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.origin,
    aws_s3_object.beach_not_replicated # <-- only added to show an existing object is not replicated
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.origin.bucket

  rule {
    id     = "DemoReplicationRule"
    status = "Enabled"

    # filter is required with delete_marker_replication
    filter {
      prefix = ""
    }

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
    }

    delete_marker_replication {
      status = "Enabled"
    }
  }
}

resource "aws_iam_role" "replication" {
  name               = "s3-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.origin.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]

    resources = ["${aws_s3_bucket.origin.arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]

    resources = ["${aws_s3_bucket.replica.arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "s3-replication-policy"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_policy_attachment" "replication" {
  name       = "s3-replication"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}

resource "aws_s3_object" "replicated_coffee" {
  bucket       = aws_s3_bucket.origin.bucket
  key          = "coffee.jpg"
  source       = "../resources/coffee.jpg"
  content_type = "image/jpeg"

  depends_on = [aws_s3_bucket_replication_configuration.demo]
}