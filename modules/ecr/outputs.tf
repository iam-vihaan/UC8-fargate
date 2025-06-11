output "patient_service_repository_url" {
  description = "URL of the patient service ECR repository"
  value       = aws_ecr_repository.patient_service.repository_url
}

output "appointment_service_repository_url" {
  description = "URL of the appointment service ECR repository"
  value       = aws_ecr_repository.appointment_service.repository_url
}

output "patient_service_repository_arn" {
  description = "ARN of the patient service ECR repository"
  value       = aws_ecr_repository.patient_service.arn
}

output "appointment_service_repository_arn" {
  description = "ARN of the appointment service ECR repository"
  value       = aws_ecr_repository.appointment_service.arn
}

output "patient_service_repository_name" {
  description = "Name of the patient service ECR repository"
  value       = aws_ecr_repository.patient_service.name
}

output "appointment_service_repository_name" {
  description = "Name of the appointment service ECR repository"
  value       = aws_ecr_repository.appointment_service.name
}
