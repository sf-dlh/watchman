provider "aws" {
    region = var.aws_region
}

## Network rsrcs 
resource "aws_vpc" "watchman_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "Watchman VPC"
  }
}

resource "aws_subnet" "watchman_vpc_subnet" {
    vpc_id = aws_vpc.watchman_vpc.id
    cidr_block = var.subnet_cidr

    availability_zone = "${var.aws_region}a"
    map_public_ip_on_launch = true                  # pour ec2 later

    tags = {
        Name = "Watchman Subnet 1"
    }

    depends_on = [ aws_internet_gateway.watchman_vpc_gateway ]
}

## Connectivity rsrcs
resource "aws_internet_gateway" "watchman_vpc_gateway" {
    vpc_id = aws_vpc.watchman_vpc.id
}

resource "aws_route_table" "watchman_vpc_routingTable" {
    vpc_id = aws_vpc.watchman_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.watchman_vpc_gateway.id
    }
}

resource "aws_route_table_association" "watchman_vpc_association" {
    subnet_id = aws_subnet.watchman_vpc_subnet.id
    route_table_id = aws_route_table.watchman_vpc_routingTable.id
}

## Security rsrcs

resource "aws_security_group" "ssh_ok" {
    name = "allow_ssh"
    vpc_id = aws_vpc.watchman_vpc.id

    description = "ssh security group for watchman"
  
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ok_ingress" {
    security_group_id = aws_security_group.ssh_ok.id
    description = "allows ssh"

    ip_protocol = "tcp"
    from_port = 22
    to_port = 22

    cidr_ipv4 = "${var.ip}/32" # whitelist for now, add bastion or ssm apres

}

resource "aws_vpc_security_group_egress_rule" "egress_let_me_out" {
    security_group_id = aws_security_group.ssh_ok.id
    description = "all outbound"

    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}

