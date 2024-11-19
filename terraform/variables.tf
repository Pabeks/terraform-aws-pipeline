variable "aws_region" {
    type = string
    description = "prefered aws region to deploy resorces to"
  
}

# AWS Instance_type Variable
variable "instance_type" {
    type = string
    description = "aws instance type for server"
}

# VPC CIDR Variable
variable "vpc_cidr" {
    type = string
    description = "vpc cidr block"
}

# Public Subnet Variables
variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string

}

# Private Subnet Variables
variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        =string

}

variable "home_directory" {
  description = "Path to the user's home directory"
  type        = string
  
}

variable "ingress" {
    type = list(number)
    description = "list of ingress port values"
    
}

variable "egress" {
    type = list(number)
    description = "list of egress port values"
   
}