# RDS Point-in-Time Recovery (PITR) setup
# Best Practices 2025: IaC, observability, tags, ≤300 LOC
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "db_identifier" {
  type        = string
  description = "Identifier of primary RDS instance"
}

variable "snapshot_retention_days" {
  type    = number
  default = 35
}

locals {
  tags = {
    owner       = "video-platform"
    environment = "prod"
    managed-by  = "terraform"
    sprint      = "8"
  }
}

# Enable automated backups on primary instance
resource "aws_db_instance" "primary" {
  identifier = var.db_identifier

  # ... other settings via variables or tfvars (omitted for brevity) ...

  backup_retention_period = var.snapshot_retention_days
  deletion_protection     = true

  tags = merge(local.tags, {
    Name = "${var.db_identifier}-primary"
  })
}

# PITR restore cluster placeholder (on-demand)
resource "aws_db_cluster" "pitr_restore" {
  count              = var.create_restore ? 1 : 0
  engine             = aws_db_instance.primary.engine
  engine_version     = aws_db_instance.primary.engine_version
  availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]

  source_db_cluster_identifier = aws_db_instance.primary.arn
  restore_type                 = "full-copy"
  snapshot_identifier          = var.restore_snapshot_id

  tags = merge(local.tags, {
    Name = "pitr-restore-${var.db_identifier}"
  })
}

variable "create_restore" {
  description = "Set to true to create a restore cluster immediately"
  type        = bool
  default     = false
}

variable "restore_snapshot_id" {
  description = "Snapshot ID to restore from (when create_restore=true)"
  type        = string
  default     = ""
}

# CloudWatch alarm – backup failures
resource "aws_cloudwatch_metric_alarm" "backup_failed" {
  alarm_name          = "rds_backup_failed_${var.db_identifier}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "BackupStorageFull"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Backup failures detected for ${var.db_identifier}"
  tags                = local.tags
}