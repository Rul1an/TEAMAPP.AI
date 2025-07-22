# AWS FIS – Kinesis outage experiment
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" { region = var.region }

variable "region" { type = string default = "eu-west-1" }
variable "fis_role_arn" { type = string }
variable "stream_arn" { type = string }

locals { tags = { owner = "video-platform", sprint = "8", environment = "chaos" } }

resource "aws_cloudwatch_log_group" "fis_kinesis" {
  name              = "/fis/kinesis_outage"
  retention_in_days = 14
  tags              = local.tags
}

resource "aws_fis_experiment_template" "kinesis_outage" {
  description = "Simulate Kinesis outage by blocking network"
  role_arn    = var.fis_role_arn

  stop_conditions { source = "none" }
  tags = merge(local.tags, { Name = "fis-kinesis-outage" })

  log_configuration {
    cloudwatch_logs_configuration { log_group_arn = aws_cloudwatch_log_group.fis_kinesis.arn }
  }

  action {
    name        = "kinesis-blackhole"
    description = "Drop all traffic to Kinesis stream"
    action_id   = "aws:fis:inject-network-blackhole"

    target {
      resource_type = "aws:kinesis:stream"
      resource_arns = [var.stream_arn]
    }

    parameters = { duration = "PT5M" }
  }
}