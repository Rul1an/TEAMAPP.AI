# Drift Monitoring – GCP Pub/Sub resources
# Sprint 12 – Terraform ≤300 LOC

terraform {
  required_version = ">= 1.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

############################
# 🔧 Variables
############################
variable "project_id" {
  description = "GCP project id"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west4"
}

variable "argo_events_webhook" {
  description = "Argo Events webhook URL that receives Pub/Sub push messages"
  type        = string
}

variable "argo_events_audience" {
  description = "OIDC audience value expected by Argo Events"
  type        = string
  default     = "argo-events"
}

locals {
  tags = {
    managed-by = "terraform"
    sprint     = "12"
    system     = "mlops-drift-monitoring"
  }
}

############################
# ☁️ Pub/Sub Topic & Subscription
############################
resource "google_pubsub_topic" "drift_alerts" {
  name   = "drift-alerts"
  labels = local.tags
}

# Service account used for push delivery (OIDC)
resource "google_service_account" "pubsub_push" {
  account_id   = "pubsub-argo-push"
  display_name = "Pub/Sub → Argo Events push service account"
}

# Allow SA to create OIDC tokens
resource "google_service_account_iam_member" "allow_token_creator" {
  service_account_id = google_service_account.pubsub_push.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.pubsub_push.email}"
}

resource "google_pubsub_subscription" "drift_alerts_push" {
  name  = "drift-alerts-to-argo"
  topic = google_pubsub_topic.drift_alerts.name

  push_config {
    push_endpoint = var.argo_events_webhook
    oidc_token {
      service_account_email = google_service_account.pubsub_push.email
      audience             = var.argo_events_audience
    }
  }

  ack_deadline_seconds = 20
  labels               = local.tags
}