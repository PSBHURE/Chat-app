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
  type = string
}

variable "default_tags" {
  type = map(string)
  default = {}
}

variable "volume_size" {
  type = number
  default = 15
}

variable "ami_type" {
  type = string
  default = "ami-021a584b49225376d"
}

variable "instance_type" {
  type = string
  default = "t2.small"
}