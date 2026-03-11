output "alb_dns_name" {
  value = module.alb.alb_dns
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}