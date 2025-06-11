# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ServiceName", "${var.project_name}-${var.environment}-patient-service", "ClusterName", var.ecs_cluster_name],
            [".", ".", "ServiceName", "${var.project_name}-${var.environment}-appointment-service", "ClusterName", var.ecs_cluster_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "ECS Service CPU Utilization"
          period  = 300
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "MemoryUtilization", "ServiceName", "${var.project_name}-${var.environment}-patient-service", "ClusterName", var.ecs_cluster_name],
            [".", ".", "ServiceName", "${var.project_name}-${var.environment}-appointment-service", "ClusterName", var.ecs_cluster_name]
          ]
          view    = "timeSeries"
          stacked = false
          region  = data.aws_region.current.name
          title   = "ECS Service Memory Utilization"
          period  = 300
        }
      },
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6

        properties = {
          query   = "SOURCE '/ecs/${var.project_name}-${var.environment}/patient-service'\n| fields @timestamp, @message\n| sort @timestamp desc\n| limit 100"
          region  = data.aws_region.current.name
          title   = "Patient Service Recent Logs"
        }
      }
    ]
  })
}

# CloudWatch Alarm for High CPU Utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ECS CPU utilization"
  alarm_actions       = []

  dimensions = {
    ClusterName = var.ecs_cluster_name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-high-cpu-alarm"
    Environment = var.environment
  }
}

# Data source for current AWS region
data "aws_region" "current" {}
