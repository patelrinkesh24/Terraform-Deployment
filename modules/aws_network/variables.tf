# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}

# Provision public subnets in custom VPC
variable "public_cidr_blocks" {
  default     = ["10.20.0.0/24", "10.20.1.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Provision private subnets in custom VPC
variable "private_cidr_blocks" {
  default     = ["10.20.3.0/24", "10.20.4.0/24"]
  type        = list(string)
  description = "priVATE Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.20.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable to signal the current environment 
variable "env" {
  default     = "devrp"
  type        = string
  description = "Deployment Environment"
}

variable "enable_nat_gateway" {
  default = true
  type = bool
  description = "Enabling nat gatewat"
}


variable "enable_internet_gateway" {
  default = true
  type = bool
  description = "Enabling internet gatewat"
}

variable "enable_dns_hostnames" {
  default = false
  type = bool
  description = "Enabling dns hostnames"
}