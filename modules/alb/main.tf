# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb"
    Environment = var.environment
  }
}

# Target Group for Patient Service
resource "aws_lb_target_group" "patient_service" {
  name     = "${var.project_name}-${var.environment}-patient-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-patient-tg"
    Service     = "patient-service"
    Environment = var.environment
  }
}

# Target Group for Appointment Service
resource "aws_lb_target_group" "appointment_service" {
  name     = "${var.project_name}-${var.environment}-apmt-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-appointment-tg"
    Service     = "appointment-service"
    Environment = var.environment
  }
}

# ALB Listener
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Healthcare Application - Try /patients or /appointments"
      status_code  = "404"
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-alb-listener"
    Environment = var.environment
  }
}

# Listener Rule for Patient Service
resource "aws_lb_listener_rule" "patient_service" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.patient_service.arn
  }

  condition {
    path_pattern {
      values = ["/patients*"]
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-patient-rule"
    Service     = "patient-service"
    Environment = var.environment
  }
}

# Listener Rule for Appointment Service
resource "aws_lb_listener_rule" "appointment_service" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.appointment_service.arn
  }

  condition {
    path_pattern {
      values = ["/appointments*"]
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-appointment-rule"
    Service     = "appointment-service"
    Environment = var.environment
  }
}

# Health check rule for both services
resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_lb_listener.main.arn
  priority     = 50

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{\"status\":\"healthy\",\"services\":[\"patient-service\",\"appointment-service\"]}"
      status_code  = "200"
    }
  }

  condition {
    path_pattern {
      values = ["/health"]
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-health-rule"
    Environment = var.environment
  }
}
