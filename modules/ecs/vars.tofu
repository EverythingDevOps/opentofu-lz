variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "worker_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 2
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
