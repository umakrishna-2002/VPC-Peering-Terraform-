variable "vpc_cidr1" {
    description = "CIDR block of vpc-1"
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_cidr2" {
    description = "CIDR block for vpc-2"
    type = string
    default = "20.0.0.0/16"
}

variable "igw_1" {
    description = "Name of igw-1"
    type = string
    default = "IGW-1"
}

variable "igw_2" {
    description = "Name of igw-2"
    type = string
    default = "IGW-2"
}

variable "rt_1" {
    description = "Name of Route-Table-1"
    type = string
    default = "Route-table1"
}

variable "rt_2" {
    description = "Name of Route-Table-2"
    type = string
    default = "Route-table2"
}

variable "sn1" {
    description = "Name of subnet-1"
    type = string
    default = "Public-Subnet-1"
}

variable "sn2" {
    description = "Name of subnet-2"
    type = string
    default = "Public-Subnet-2"
}

variable "sn1_cidr" {
    default = "10.0.1.0/24"
}

variable "sn1_cidr_private" {
    default = "10.0.2.0/24"
}

variable "sn2_cidr" {
    default = "20.0.1.0/24" # Ensure this is within the VPC CIDR block
}

variable "sn2_cidr_private" {
    default = "20.0.2.0/24"
}

variable "availability_zone_1" {
    description = "AZ for Subnets-1"
    type = string
    default = "us-east-1a"
}

variable "availability_zone_2" {
    description = "AZ for Subnets-2"
    type = string
    default = "us-east-1b"
}

variable "ami_id" {
    description = "AMI-ID for all the isntances"
    type = string
    default = "ami-08b5b3a93ed654d19"
}