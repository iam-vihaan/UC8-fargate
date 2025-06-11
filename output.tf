output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the load balancer"
  value       = module.alb.alb_zone_id
}

output "ecr_patient_repository_url" {
  description = "URL of the patient service ECR repository"
  value       = module.ecr.patient_service_repository_url
}

output "ecr_appointment_repository_url" {
  description = "URL of the appointment service ECR repository"
  value       = module.ecr.appointment_service_repository_url
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "cloudwatch_log_group_names" {
  description = "Names of CloudWatch log groups"
  value       = module.cloudwatch.log_group_names
}
