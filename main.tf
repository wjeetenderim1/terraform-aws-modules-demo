resource "random_id" "rand" {
  byte_length = 4
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "security" {
  source  = "./modules/security"
  vpc_id  = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.private_subnet_ids[0]
  instance_type     = var.instance_type
  security_group_id = module.security.ec2_sg_id
  instance_profile  = module.iam_role.instance_profile_name
}

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  target_instance_id = module.ec2.instance_id
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "IM-demo-bucket-${random_id.rand.hex}"
}

module "iam_role" {
  source = "./modules/iam_role"
}

# module "rds" {

#   source = "./modules/rds"

#   db_name  = "appdb"
#   username = "admin"
#   password = "StrongPassword123!"

#   vpc_id     = module.vpc.vpc_id
#   subnet_ids = module.vpc.private_subnet_ids

# }