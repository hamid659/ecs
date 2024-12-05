variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
  type        = list(string)
}


variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "ecr_uri" {
  description = "The URI of the ECR repository for the Flask app"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "instance_type" {
    default     = "t2.micro"
}

variable "desired_count" {
  description = "The desired count of ECS tasks"
  type        = number
  default     = 1
}

variable "min_size" {
  type        = number
  default     = 1
 }

variable "max_size" {
  type        = number
  default     = 3
 }