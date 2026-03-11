variable "name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default = "ingram"
}

variable "launch_template_id" {
  description = "Launch template ID"
  type        = string
}

variable "launch_template_version" {
  description = "Launch template version"
  type        = string
  default     = "$Latest"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "health_check_type" {
  description = "Health check type (EC2 or ELB)"
  type        = string
  default     = "ELB"
  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "Health check type must be either 'EC2' or 'ELB'."
  }
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
  default     = []
}

variable "load_balancers" {
  description = "List of classic load balancer names"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "List of termination policies"
  type        = list(string)
  default     = ["Default"]
}

variable "enabled_metrics" {
  description = "List of metrics to enable"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
}

variable "protect_from_scale_in" {
  description = "Protect instances from scale in"
  type        = bool
  default     = false
}

variable "wait_for_capacity_timeout" {
  description = "Wait for capacity timeout"
  type        = string
  default     = "10m"
}

variable "tags" {
  description = "Tags to apply to the Auto Scaling Group"
  type        = map(string)
  default     = {}
}
