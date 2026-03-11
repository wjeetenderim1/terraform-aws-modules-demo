variable "subnet_id" {}
variable "instance_type" {}
variable "security_group_id" {}
variable "instance_profile" {
  description = "IAM instance profile for EC2."
  type        = string
}