resource "aws_autoscaling_group" "web_scaling_group" {
  name                      = "apache-auto-scaling-group-798897"
  max_size                  = var.count_instances.max
  desired_capacity          = var.count_instances.desired
  min_size                  = var.count_instances.min
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.web_config.name
  vpc_zone_identifier       = local.default
  target_group_arns         = ["${aws_lb_target_group.test.arn}"]
}

# ASG policy
resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "production-web-cluster-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.web_scaling_group.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "60"

  }
}