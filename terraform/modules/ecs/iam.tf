resource "aws_iam_role" "ecs_instance_role" {
  name               = "ecsInstanceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_instance_policy" {
  name        = "ecsInstancePolicy"
  description = "Allow EC2 instances to interact with ECS and CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecs:UpdateContainerInstancesState",
          "ecs:DiscoverPollEndpoint",
          "ecs:RegisterContainerInstance"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attachment" {
  policy_arn = aws_iam_policy.ecs_instance_policy.arn
  role       = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"
  role = aws_iam_role.ecs_instance_role.name
}
