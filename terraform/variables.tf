variable "vpc_cidr_block" {
    default = "10.16.0.0/16"
    description = "Which VPC CIDR"
}

variable "subnet_cidr" {
    default = "10.16.0.0/20"
    description = "Which subnet CIDR"
}

variable "aws_region" {
    default = "us-east-1"
    description = "Which AWS Region"
}

variable "ip" {
    type = string
}