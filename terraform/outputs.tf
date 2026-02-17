output "vpc_id" {
    description = "Watchman VPC attributes"
    value =  { 
        id = aws_vpc.watchman_vpc.id
        arn = aws_vpc.watchman_vpc.arn
        cidr = aws_vpc.watchman_vpc.cidr_block
    }
}

output "watchman_host_ip" {
    description = "IP of current ec2 watchman host"
    value = aws_instance.watchman.public_ip
}