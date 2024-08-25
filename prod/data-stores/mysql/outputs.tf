output "address" {
  value       = aws_db_instance.db_instance.address
  description = "Database endpoint"
}

output "port" {
  value       = aws_db_instance.db_instance.port
  description = "The port the database is listing on"
}
