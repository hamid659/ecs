data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
} 

resource "aws_launch_template" "ecs_launch_template" {
  name = "${var.cluster_name}-ecs-launch-template"
  image_id = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  iam_instance_profile { name = aws_iam_instance_profile.ecs_instance_profile.name }

  depends_on = [aws_iam_role.ecs_instance_role]
}

resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity = 1
  max_size = 2
  min_size = 1
  vpc_zone_identifier = var.subnets
  launch_template {
    id = aws_launch_template.ecs_launch_template.id
    version             = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.ecs_launch_template]
}