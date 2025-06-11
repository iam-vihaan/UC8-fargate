# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Environment = var.environment
  }
}

# CloudWatch Log Group for Patient Service
resource "aws_cloudwatch_log_group" "patient_service" {
  name              = "/ecs/${var.project_name}-${var.environment}/patient-service"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-patient-service-logs"
    Service     = "patient-service"
    Environment = var.environment
  }
}

# CloudWatch Log Group for Appointment Service
resource "aws_cloudwatch_log_group" "appointment_service" {
  name              = "/ecs/${var.project_name}-${var.environment}/appointment-service"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-appointment-service-logs"
    Service     = "appointment-service"
    Environment = var.environment
  }
}

# ECS Task Definition for Patient Service
resource "aws_ecs_task_definition" "patient_service" {
  family                   = "${var.project_name}-${var.environment}-patient-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "patient-service"
      image = "${var.ecr_patient_repo_url}:latest"
      
      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:${var.app_port}/health || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.patient_service.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        {
          name  = "NODE_ENV"
          value = var.environment
        },
        {
          name  = "PORT"
          value = tostring(var.app_port)
        }
      ]

      essential = true
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-patient-service-task"
    Service     = "patient-service"
    Environment = var.environment
  }
}

# ECS Task Definition for Appointment Service
resource "aws_ecs_task_definition" "appointment_service" {
  family                   = "${var.project_name}-${var.environment}-appointment-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "appointment-service"
      image = "${var.ecr_appointment_repo_url}:latest"
      
      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "curl -f http://localhost:${var.app_port}/health || exit 1"
        ]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.appointment_service.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = [
        {
          name  = "NODE_ENV"
          value = var.environment
        },
        {
          name  = "PORT"
          value = tostring(var.app_port)
        }
      ]

      essential = true
    }
  ])

  tags = {
    Name        = "${var.project_name}-${var.environment}-appointment-service-task"
    Service     = "appointment-service"
    Environment = var.environment
  }
}

# ECS Service for Patient Service
resource "aws_ecs_service" "patient_service" {
  name            = "${var.project_name}-${var.environment}-patient-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.patient_service.arn
  desired_count   = var.desired_capacity
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arns.patient_service
    container_name   = "patient-service"
    container_port   = var.app_port
  }

  depends_on = [var.target_group_arns]

  tags = {
    Name        = "${var.project_name}-${var.environment}-patient-service"
    Service     = "patient-service"
    Environment = var.environment
  }
}

# ECS Service for Appointment Service
resource "aws_ecs_service" "appointment_service" {
  name            = "${var.project_name}-${var.environment}-appointment-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.appointment_service.arn
  desired_count   = var.desired_capacity
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arns.appointment_service
    container_name   = "appointment-service"
    container_port   = var.app_port
  }

  depends_on = [var.target_group_arns]

  tags = {
    Name        = "${var.project_name}-${var.environment}-appointment-service"
    Service     = "appointment-service"
    Environment = var.environment
  }
}

# Data source for current AWS region
data "aws_region" "current" {}
