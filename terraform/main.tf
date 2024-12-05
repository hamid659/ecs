
module "ecs" {
  source = "./modules/ecs" 
  cluster_name   = var.cluster_name
  service_name   = var.service_name
  vpc_id         = var.vpc_id
  subnets        = var.subnets
  instance_type  = var.instance_type
  desired_count  = var.desired_count
  max_size       = var.min_size
  min_size       = var.max_size
  ecr_uri        = var.ecr_uri
}




