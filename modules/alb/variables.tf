variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "alb_sg_id" {}
variable "target_instance_id" {
  description = "EC2 instance to attach"
  type        = string
  default     = null
}