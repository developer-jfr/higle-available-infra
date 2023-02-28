# Application Load Balancer Target Group
resource "aws_lb_target_group" "test" {
  name     = "apache-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.main.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = 80
    matcher  = "200"
  }
}



# Application Load Balancer
resource "aws_lb" "test" {
  name               = "team-4-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = local.default

  tags = {
    Environment = "production"
  }
}


# ALB HTTP listener for target
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}