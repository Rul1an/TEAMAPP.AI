# AWS Fault Injection Simulator – network latency experiment
# Best Practices 2025: clean IaC, ≤300 LOC, observability, owner tags.
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
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

locals {
  tags = {
    owner        = "video-platform"
    environment  = "chaos"
    managed-by   = "terraform"
    sprint       = "8"
  }
}

resource "aws_cloudwatch_log_group" "fis_logs" {
  name = "/fis/network_latency"
  retention_in_days = 14
  tags = local.tags
}

resource "aws_fis_experiment_template" "network_latency_1s" {
  description = "Inject 1s latency in eu-west-1"
  role_arn    = var.fis_role_arn

  stop_conditions {
    source = "none"
  }

  tags = merge(local.tags, {
    Name = "fis-network-latency-1s"
  })

  log_configuration {
    cloudwatch_logs_configuration {
      log_group_arn = aws_cloudwatch_log_group.fis_logs.arn
    }
  }

  action {
    name        = "inject-latency"
    description = "Add 1 s delay"
    action_id   = "aws:fis:inject-network-latency"

    target {
      resource_type = "aws:ec2:instance"
      resource_arns = var.target_instance_arns
    }

    parameters = {
      duration = "PT1S" # ISO 8601 duration 1 second
    }
  }

  # Stop condition alarm – if latency > 2s then stop
  stop_condition {
    source = "aws:cloudwatch:alarm"
    value  = aws_cloudwatch_metric_alarm.high_latency.arn
  }
}

variable "fis_role_arn" {
  description = "IAM role that FIS will assume"
  type        = string
}

variable "target_instance_arns" {
  description = "Target EC2 instance ARNs"
  type        = list(string)
}

# Observability – CloudWatch metric+alarm
resource "aws_cloudwatch_metric_alarm" "high_latency" {
  alarm_name          = "fis_network_latency_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "LatencyMs"
  namespace           = "VideoPlatform/GameDay"
  period              = 60
  statistic           = "Average"
  threshold           = 2000
  alarm_description   = "Triggers when latency >= 2s during experiment"
  tags                = local.tags
}