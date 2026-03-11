variable "db_name" {
  description = "Database name"
}

variable "username" {
  description = "Master username"
}

variable "password" {
  description = "Master password"
  sensitive   = true
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
}