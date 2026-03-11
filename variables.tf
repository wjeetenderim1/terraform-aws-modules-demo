variable "region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t2.micro"
}
variable "db_host" {
  description = "RDS endpoint"
  type        = string
}