output "alb_dns_name" {
  value = module.alb.alb_dns
}

# output "rds_endpoint" {
#   value = module.aws_db_instance.rds.endpoint
# }