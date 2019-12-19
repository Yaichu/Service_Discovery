output "aws_instance_public_dns" {
  value = aws_instance.consul_server[*].public_dns
}

# output "aws_instance_public_dns" {
#   value = aws_instance.consul_apache[*].public_dns
# }
