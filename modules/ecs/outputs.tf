output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

output "patient_service_task_definition_arn" {
  description = "ARN of the patient service task definition"
  value       = aws_ecs_task_definition.patient_service.arn
}

output "appointment_service_task_definition_arn" {
  description = "ARN of the appointment service task definition"
  value       = aws_ecs_task_definition.appointment_service.arn
}

output "patient_service_service_name" {
  description = "Name of the patient service ECS service"
  value       = aws_ecs_service.patient_service.name
}

output "appointment_service_service_name" {
  description = "Name of the appointment service ECS service"
  value       = aws_ecs_service.appointment_service.name
}

output "log_group_names" {
  description = "Names of CloudWatch log groups"
  value = {
    patient_service     = aws_cloudwatch_log_group.patient_service.name
    appointment_service = aws_cloudwatch_log_group.appointment_service.name
  }
}
