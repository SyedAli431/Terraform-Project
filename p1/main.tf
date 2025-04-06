# create VPC
resource "aws_vpc" "lab5-vpc" {
    cidr_block = "100.64.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {Name = "lab5-vpc"}
}
# Create Internet Gateway
resource "aws_internet_gateway" "igw-test" {
    vpc_id = aws_vpc.lab5-vpc.id
    tags = {Name = "igw-test"}
}
# Create public routing table
resource "aws_route_table" "RT-public" {
    vpc_id = aws_vpc.lab5-vpc.id
}
#create public route for public route table
resource "aws_route" "public-route" {
     route_table_id = aws_route_table.RT-public.id
     destination_cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw-test.id
}
#Public subnet 
resource "aws_subnet" "SN-public-1" {
    vpc_id = aws_vpc.lab5-vpc.id
    cidr_block = "100.64.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {Name = "SN-public-1"}
}
#Private subnet
resource "aws_subnet" "SN-private-1" {
    vpc_id = aws_vpc.lab5-vpc.id
    cidr_block = "100.64.2.0/24"
    availability_zone = "us-east-1a"
    tags = {Name = "SN-private-1"}

}
# assoicate routing table to public subnet 1
resource "aws_route_table_association" "public-association-1"{
    route_table_id = aws_route_table.RT-public.id
    subnet_id = aws_subnet.SN-public-1.id

}
# Create Security Group
resource "aws_security_group" "sg-tf" {
    name = "Allow SSH and HTTP traffic"
    description = "Allo SSH and HTTP"
    vpc_id = aws_vpc.lab5-vpc.id
    tags = {Name = "sg-tf"}
}
#create SSH rule for security group
resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
    security_group_id = aws_security_group.sg-tf.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    to_port = 22
    ip_protocol = "tcp"
}
#create HTTP rule for security group
resource "aws_vpc_security_group_ingress_rule" "allow-http" {
    security_group_id = aws_security_group.sg-tf.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
}
#create outbound rule to allow all trafiic
resource "aws_vpc_security_group_egress_rule" "allow-all" {
    security_group_id = aws_security_group.sg-tf.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
#create a VM in public subnet
resource "aws_instance" "VM1"{
    ami = data.aws_ami.latest_ami.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.SN-public-1.id
    security_groups = [aws_security_group.sg-tf.id]
    key_name = "new-key"
    tags = {Name = "vm1"}
}
#create a VM in private subnet
resource "aws_instance" "VM2"{
    ami = data.aws_ami.latest_ami.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.SN-private-1.id
    security_groups = [aws_security_group.sg-tf.id]
    key_name = "new-key"
    tags = {Name = "vm2"}
}