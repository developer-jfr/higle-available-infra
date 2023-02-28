# ALB Domain Name
output "ALB-Domain-Name" {
  value = aws_lb.test.dns_name
}
