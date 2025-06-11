output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = aws_lb.main.zone_id
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.main.arn
}

output "target_group_arns" {
  description = "ARNs of the target groups"
  value = {
    patient_service     = aws_lb_target_group.patient_service.arn
    appointment_service = aws_lb_target_group.appointment_service.arn
  }
}

output "patient_service_target_group_arn" {
  description = "ARN of the patient service target group"
  value       = aws_lb_target_group.patient_service.arn
}

output "appointment_service_target_group_arn" {
  description = "ARN of the appointment service target group"
  value       = aws_lb_target_group.appointment_service.arn
}

output "listener_arn" {
  description = "ARN of the ALB listener"
  value       = aws_lb_listener.main.arn
}
