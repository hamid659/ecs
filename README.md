# ECS Terraform Module
This Terraform module provisions an Amazon ECS cluster with an Auto Scaling group, Application Load Balancer (ALB), and associated resources.

## Features
- ECS Cluster: Creates an ECS cluster to run tasks.
- Launch Template: Configures EC2 instances with IAM roles, security groups,  and the latest Amazon ECS optimized AMI.
- Auto Scaling: Manages the desired number of EC2 instances within the cluster.
- Application Load Balancer (ALB): Routes traffic to ECS tasks.
- Auto-scaling Policies: Adjusts ECS service capacity based on CPU utilization.


## Usage
```
module "ecs" {
  source = "./modules/ecs" # Update with the correct path

  cluster_name   = "flask-ecs-cluster"
  vpc_id         = "vpc-eac8d788"
  subnets        = ["subnet-06223a64", "subnet-83a2d2ab"]
  instance_type  = "t2.micro"
  desired_count  = 1
  max_size       = 2
  min_size       = 1
}

```
