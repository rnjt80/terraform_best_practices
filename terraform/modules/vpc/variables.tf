variable "environment_name" {
  type        = string
  description = "Name of the environment (e.g., dev, prod)"
}

variable "cidr_block" {=
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones to create subnets in"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT Gateway for private subnets"
}

variable "single_nat_gateway" {
  type        = bool
  default     = false
  description = "Create a single NAT Gateway in one public subnet (cost-effective for dev/test)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to VPC resources"
}