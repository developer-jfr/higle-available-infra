# ============== Networking =======================

# default VPC
resource "aws_default_vpc" "main" {
  tags = {
    Name = "Default VPC"
  }
}


data "aws_subnets" "all_subnets" {
  filter {
    name   = "tag:Name"
    values = ["default-subnet"]
  }
}


# security group for ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_default_vpc.main.id
  name   = "alb-sg-terraform"
  dynamic "ingress" {
    for_each = var.alb_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group-23"
  }
}


# security group for Apache Instance
resource "aws_security_group" "apache_sg" {
  name        = "apache-allow-alb"
  description = "Allow Apache inbound traffic from ALB"
  vpc_id      = aws_default_vpc.main.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"

    security_groups = [
      "${aws_security_group.alb_sg.id}",
    ]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "apache-allow-alb"
  }
}