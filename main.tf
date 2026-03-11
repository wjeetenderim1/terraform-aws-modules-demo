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

# module "ec2" {
#   source            = "./modules/ec2"
#   subnet_id         = module.vpc.private_subnet_ids[0]
#   instance_type     = var.instance_type
#   security_group_id = module.security.ec2_sg_id
#   instance_profile  = module.iam_role.instance_profile_name
# }

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "IM-demo-bucket-${random_id.rand.hex}"
}

module "iam_role" {
  source = "./modules/iam_role"
}

module "rds" {

  source = "./modules/rds"

  db_name  = "appdb"
  username = "admin"
  password = "StrongPassword123!"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

}


module "launch_template" {

  source = "./modules/launch_template"

  name = "web-template"

  security_group_ids = [module.security.ec2_sg_id]

  instance_type = "t2.micro"

  db_host = module.rds.rds_endpoint

  user_data = <<EOF
#!/bin/bash

yum update -y

# Install Apache + PHP
amazon-linux-extras enable php8.0
yum clean metadata
yum install -y httpd php php-mysqlnd mysql

systemctl enable httpd
systemctl start httpd

cd /var/www/html

# Download WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# Permissions
chown -R apache:apache /var/www/html

# Get RDS endpoint
DB_HOST="${var.db_host}"

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/appdb/" wp-config.php
sed -i "s/username_here/admin/" wp-config.php
sed -i "s/password_here/StrongPassword123!/" wp-config.php
sed -i "s/localhost/$DB_HOST/" wp-config.php
EOF

}

module "autoscaling" {

  source = "./modules/autoscaling_group"

  name = "ingram-asg"

  launch_template_id = module.launch_template.launch_template_id

  subnet_ids = module.vpc.private_subnet_ids

  target_group_arns = [module.alb.target_group_arn]

  min_size = 1
  max_size = 1
  desired_capacity = 1

}