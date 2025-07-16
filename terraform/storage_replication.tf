terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.us-east-1, aws.ap-southeast-1]
    }
  }
}

provider "aws" {
  region = var.primary_region
}

variable "primary_region" {
  description = "Primary AWS region (active-active)"
  type        = string
  default     = "eu-west-1"
}

variable "replica_regions" {
  description = "Additional regions for active-active setup"
  type        = list(string)
  default     = ["us-east-1", "ap-southeast-1"]
}

resource "aws_kms_key" "edge_storage" {
  description         = "KMS key for geo-replicated edge storage (CMEK)"
  enable_key_rotation = true
}

resource "aws_s3_bucket" "primary" {
  bucket        = "veo-edge-storage-primary-${random_id.suffix.hex}"
  force_destroy = true

  # SSE and versioning are defined in separate resources (provider v5+)
}

resource "random_id" "suffix" {
  byte_length = 4
}

# locals block removed – we iterate directly over `var.replica_regions`

resource "aws_s3_bucket" "replica" {
  for_each = toset(var.replica_regions)

  bucket        = "veo-edge-storage-${each.key}-${random_id.suffix.hex}"
  force_destroy = true

  providers = {
    aws = aws[each.key]
  }

  # SSE, versioning and lifecycle are defined in dedicated resources (provider v5+)
}

resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication_policy" {
  name   = "s3-replication-policy-${random_id.suffix.hex}"
  role   = aws_iam_role.replication_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectLegalHold",
          "s3:GetObjectVersionTagging",
          "s3:GetObjectRetention",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = [
          aws_s3_bucket.primary.arn,
          "${aws_s3_bucket.primary.arn}/*"
        ]
      },
      {
        Effect   = "Allow",
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = [for b in aws_s3_bucket.replica : "${b.arn}/*"]
      }
    ]
  })
}

# Attach replication configuration to primary bucket
data "aws_iam_role" "rep_role" {
  arn = aws_iam_role.replication_role.arn
}

resource "aws_s3_bucket_replication_configuration" "primary_replication" {
  bucket = aws_s3_bucket.primary.id
  role   = data.aws_iam_role.rep_role.arn

  rule {
    id     = "replicate-all-objects"
    status = "Enabled"

    filter {
      prefix = ""
    }

    destination {
      bucket        = one(values(aws_s3_bucket.replica)).arn # first replica as example
      storage_class = "STANDARD"
    }
  }
}

################################################################################
#  NEW RESOURCES – provider v5-compatible bucket configuration
################################################################################

# Primary bucket configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.edge_storage.arn
    }
  }
}

resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Per-region KMS keys for replica buckets
resource "aws_kms_key" "edge_storage_replica" {
  for_each = toset(var.replica_regions)

  description         = "KMS key for edge storage in ${each.key}"
  enable_key_rotation = true

  providers = {
    aws = aws[each.key]
  }
}

# Replica bucket configuration – SSE
resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  for_each = aws_s3_bucket.replica

  providers = {
    aws = aws[each.key]
  }

  bucket = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.edge_storage_replica[each.key].arn
    }
  }
}

resource "aws_s3_bucket_versioning" "replica" {
  for_each = aws_s3_bucket.replica

  providers = {
    aws = aws[each.key]
  }

  bucket = each.value.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "replica" {
  for_each = aws_s3_bucket.replica

  providers = {
    aws = aws[each.key]
  }

  bucket = each.value.id

  rule {
    id     = "abort-multipart-uploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
################################################################################