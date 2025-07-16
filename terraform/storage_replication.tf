terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.edge_storage.arn
      }
    }
  }

  versioning {
    enabled = true
  }

  # Replication configuration filled later by for_each loop
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  replica_map = { for idx, reg in var.replica_regions : reg => idx }
}

resource "aws_s3_bucket" "replica" {
  for_each = local.replica_map
  bucket   = "veo-edge-storage-${each.key}-${random_id.suffix.hex}"
  provider = aws

  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 7
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.edge_storage.arn
      }
    }
  }

  versioning {
    enabled = true
  }
}

# To-Do: IAM role & bucket replication rules linking primary → replicas.