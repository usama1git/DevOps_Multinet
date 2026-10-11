output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "url" {
  description = "Open this in a browser once user_data has finished (2-3 minutes)"
  value       = "http://${aws_instance.web.public_dns}"
}
