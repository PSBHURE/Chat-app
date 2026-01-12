variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}

variable "azs" {
  description = "Availability zones"
  type = list(string)
}

variable "env" {
  description = "environment of infra"
  type = list(string)
}

variable "default_tags" {
  type = map(string)
  default = {}
}