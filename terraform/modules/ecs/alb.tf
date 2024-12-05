resource "aws_alb" "ecs_alb" {
  name            = "${var.cluster_name}-ecs-alb"
  internal        = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.ecs_sg.id]
  subnets         = var.subnets
}

resource "aws_alb_target_group" "ecs_target_group" {
  name     = "${var.cluster_name}-ecs-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_alb_listener" "ecs_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
  }
}

resource "aws_appautoscaling_target" "ecs_scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.ecs_cluster.id}/${aws_ecs_service.flask_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 1
  max_capacity       = 3
}

resource "aws_appautoscaling_policy" "scale_down" { 
    name               = "scale-down"
    policy_type        = "TargetTrackingScaling"
    resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 20

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}


resource "aws_appautoscaling_policy" "scale_up" {
  name               = "scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
    scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
    service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 50
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_out_cooldown = 60
    scale_in_cooldown  = 60
  }
}