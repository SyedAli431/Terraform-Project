resource "aws_vpc" "lab5-vpc" {
    cidr_block = "192.168.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {Name = "lab5-vpc"}
}
