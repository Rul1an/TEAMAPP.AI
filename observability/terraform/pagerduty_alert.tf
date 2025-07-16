# PagerDuty alert policy – error budget burn
# Best Practices 2025
terraform {
  required_version = ">= 1.4"
  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = ">= 2.5"
    }
  }
}

provider "pagerduty" {
  token = var.pagerduty_token
}

variable "pagerduty_token" {
  type        = string
  description = "API token (set via TF_VAR_pagerduty_token)"
}

variable "service_id" {
  description = "PagerDuty service ID"
  type        = string
}

resource "pagerduty_event_rule" "error_budget_burn" {
  service = var.service_id
  disabled = false

  condition {
    operator = "contains"
    path     = "details.monitor_name"
    value    = "Error Budget Burn"
  }

  action {
    severity = "critical"
    suppress = false
  }

  label = "Error Budget Burn"
  description = "Trigger when error budget burn alarm fires"
}