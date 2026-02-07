output "vpc_id" {
    description = "Watchman VPC attributes"
    value =  { 
        id = aws_vpc.watchman_vpc.id
        arn = aws_vpc.watchman_vpc.arn
        cidr = aws_vpc.watchman_vpc.cidr_block
    }
}
