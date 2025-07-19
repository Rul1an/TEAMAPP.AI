# AWS FIS – CPU & Memory stress experiment
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
variable "target_instance_arns" { type = list(string) }

locals { tags = { owner = "video-platform", sprint = "8", environment = "chaos" } }

resource "aws_cloudwatch_log_group" "fis_cpu_mem" {
  name              = "/fis/cpu_mem_stress"
  retention_in_days = 14
  tags              = local.tags
}

resource "aws_fis_experiment_template" "cpu_mem_stress" {
  description = "Stress CPU 80% & memory 70% for 5 minutes"
  role_arn    = var.fis_role_arn

  stop_conditions { source = "none" }
  tags = merge(local.tags, { Name = "fis-cpu-mem-stress" })

  log_configuration {
    cloudwatch_logs_configuration { log_group_arn = aws_cloudwatch_log_group.fis_cpu_mem.arn }
  }

  action {
    name        = "stress-cpu"
    description = "Increase CPU usage to 80%"
    action_id   = "aws:ssm:send-command"

    parameters = {
      documentName = "AWSFIS-RunShellScript"
      duration     = "PT5M"
      parameters   = jsonencode({
        commands = ["sudo stress -c $(nproc) --timeout 180"]
      })
    }

    target {
      resource_type = "aws:ec2:instance"
      resource_arns = var.target_instance_arns
    }
  }

  action {
    name        = "stress-memory"
    description = "Allocate 70% of memory"
    action_id   = "aws:ssm:send-command"

    parameters = {
      documentName = "AWSFIS-RunShellScript"
      duration     = "PT5M"
      parameters   = jsonencode({
        commands = ["sudo stress --vm 1 --vm-bytes $(awk '/MemAvailable/ { printf \"%d\", $2*0.7; exit }' /proc/meminfo)K --timeout 180"]
      })
    }

    target {
      resource_type = "aws:ec2:instance"
      resource_arns = var.target_instance_arns
    }
  }
}