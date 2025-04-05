resource "aws_vpc" "lab5-vpc" {
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {Name = "lab5-vpc"}
}


resource "aws_internet_gateway" "igw-example" {
    vpc_id = aws_vpc.lab5-vpc
    tags = {Name = "igw-example"}
}


resource "aws_route_table" "RT-public" {
    vpc_id = aws_vpc.lab5-vpc
}
