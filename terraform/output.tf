output "webgoat_url" {
  value = "http://${aws_instance.webgoat_server.public_ip}:8080/WebGoat"
}

output "webwolf_url" {
  value = "http://${aws_instance.webgoat_server.public_ip}:9090"
}