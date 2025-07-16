# CloudWatch SLO dashboard & synthetic canary
# Best Practices 2025: observability, ≤300 LOC
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
    owner       = "video-platform"
    environment = "prod"
    managed-by  = "terraform"
    sprint      = "8"
  }
  slo_dashboard_name = "video-platform-slo"
}

resource "aws_cloudwatch_dashboard" "slo" {
  dashboard_name = local.slo_dashboard_name
  dashboard_body = jsonencode({
    widgets = [
      {
        type  = "metric",
        x     = 0,
        y     = 0,
        width = 12,
        height= 6,
        properties = {
          metrics = [
            [ "VideoPlatform/GameDay", "LatencyMs", "RunId", "*", { "stat": "p95", "period": 60 } ]
          ],
          view     = "timeSeries",
          region   = var.region,
          title    = "p95 Latency (ms)",
        }
      },
      {
        type  = "metric",
        x     = 12,
        y     = 0,
        width = 12,
        height= 6,
        properties = {
          metrics = [
            [ {"expression": "FILL(m1,0) - FILL(m2,0)", "label": "Error Budget Burn", "id": "e1"} ],
            [ "AWS/ApiGateway", "5XXError", "ApiName", "video-api", { "stat": "Sum", "period": 60, "id": "m1" } ],
            [ "AWS/ApiGateway", "Count", "ApiName", "video-api", { "stat": "Sum", "period": 60, "id": "m2" } ]
          ],
          view     = "timeSeries",
          region   = var.region,
          title    = "Error Budget Burn",
        }
      }
    ]
  })
}

# CloudWatch Synthetics Canary – health endpoint
resource "aws_synthetics_canary" "health" {
  name       = "video-platform-canary"
  artifact_s3_location = var.s3_bucket
  runtime_version = "syn-1.0"
  handler   = "index.handler"
  start_canary = true

  schedule {
    expression = "rate(1 minute)"
  }

  run_config {
    timeout_in_seconds = 60
  }

  s3_bucket = var.s3_bucket

  code {
    handler = "index.handler"
    script  = <<EOT
const synthetics = require('Synthetics');
const log = require('SyntheticsLogger');

const apiCanaryBlueprint = async function () {
  let requestOptions = {
    hostname: process.env.TARGET_HOST,
    method: 'GET',
    path: '/health',
  };
  let response = await synthetics.executeHttpStep('Verify health', requestOptions);
  if (response.statusCode !== 200) {
    throw new Error('Non-200 response');
  }
};
exports.handler = async () => { await apiCanaryBlueprint(); };
EOT
  }

  tags = local.tags
}

variable "s3_bucket" {
  description = "S3 bucket for canary artifacts"
  type        = string
}