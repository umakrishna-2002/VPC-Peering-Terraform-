resource "aws_vpc" "example" {
    cidr_block = var.vpc_cidr1
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc-one"
    }
}

resource "aws_vpc" "example2" {
    cidr_block = var.vpc_cidr2
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "vpc-two"
    }
}

resource "aws_internet_gateway" "example-igw" {
    vpc_id = aws_vpc.example.id
    tags = {
        Name = var.igw_1
    }
}

resource "aws_internet_gateway" "example-igw2" {
    vpc_id = aws_vpc.example2.id
    tags = {
        Name = var.igw_2
    }
}

resource "aws_route_table" "example-rt1" {
    vpc_id = aws_vpc.example.id
    tags = {
        Name = var.rt_1
    }
}

resource "aws_route_table" "example-rt2" {
    vpc_id = aws_vpc.example2.id
    tags = {
        Name = var.rt_2
    }
}

// Private Route Tables
resource "aws_route_table" "private_rt1" {
    vpc_id = aws_vpc.example.id
    tags = {
        Name = "private-rt-1"
    }
}

resource "aws_route_table" "private_rt2" {
    vpc_id = aws_vpc.example2.id
    tags = {
        Name = "private-rt-2"
    }
}

// Public Route Tables
resource "aws_route_table" "public_rt1" {
    vpc_id = aws_vpc.example.id
    tags = {
        Name = "public-rt-1"
    }
}

resource "aws_route_table" "public_rt2" {
    vpc_id = aws_vpc.example2.id
    tags = {
        Name = "public-rt-2"
    }
}

resource "aws_subnet" "example-sn1" {
    vpc_id = aws_vpc.example.id
    cidr_block = var.sn1_cidr
    availability_zone = var.availability_zone_1
    map_public_ip_on_launch = true
    tags = {
        Name = var.sn1
    }
}

resource "aws_subnet" "example-sn2" {
    vpc_id = aws_vpc.example2.id
    cidr_block = var.sn2_cidr
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = true
    tags = {
        Name = var.sn2
    }
}

resource "aws_subnet" "private-sn1" {
    vpc_id = aws_vpc.example.id
    cidr_block = var.sn1_cidr_private
    availability_zone = var.availability_zone_1
    map_public_ip_on_launch = false
    tags = {
        Name = "private_subnet-1"
    }
}

resource "aws_subnet" "private-sn2" {
    vpc_id = aws_vpc.example2.id
    cidr_block = var.sn2_cidr_private
    availability_zone = var.availability_zone_2
    map_public_ip_on_launch = false
    tags = {
        Name = "private-subnet-2"
    }
}

resource "aws_route" "rt-igw" {
    route_table_id = aws_route_table.example-rt1.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-igw.id
}

resource "aws_route_table_association" "subass-1" {
    route_table_id = aws_route_table.example-rt1.id
    subnet_id = aws_subnet.example-sn1.id
}

resource "aws_route_table_association" "subass-2" {
    route_table_id = aws_route_table.example-rt2.id
    subnet_id = aws_subnet.example-sn2.id
}

resource "aws_route" "rt-igw2" {
    route_table_id = aws_route_table.example-rt2.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example-igw2.id
}

resource "aws_eip" "nat_eip1" {
    domain = "vpc"
    tags = {
        Name = "nat-eip-1"
    }
}

resource "aws_eip" "nat_eip2" {
    domain = "vpc"
    tags = {
        Name = "nat-eip-2"
    }
}

// Corrected NAT Gateway Resource Names
resource "aws_nat_gateway" "nat-gw-1" {
    allocation_id = aws_eip.nat_eip1.id
    subnet_id     = aws_subnet.example-sn1.id
    tags = {
        Name = "nat-gateway-1"
    }
}

resource "aws_nat_gateway" "nat_gw2" {
    allocation_id = aws_eip.nat_eip2.id
    subnet_id     = aws_subnet.example-sn2.id
    tags = {
        Name = "nat-gateway-2"
    }
}

// Corrected NAT Gateway Routes
resource "aws_route" "private_rt1_nat" {
    route_table_id         = aws_route_table.private_rt1.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat-gw-1.id
}

resource "aws_route" "private_rt2_nat" {
    route_table_id         = aws_route_table.private_rt2.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.nat_gw2.id
}

resource "aws_vpc_peering_connection" "vpc_peering" {
    vpc_id      = aws_vpc.example.id
    peer_vpc_id = aws_vpc.example2.id
    auto_accept = true

    tags = {
        Name = "vpc-peering-example"
    }
}

resource "aws_route" "vpc1_to_vpc2" {
    route_table_id         = aws_route_table.example-rt1.id
    destination_cidr_block = var.vpc_cidr2
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "vpc2_to_vpc1" {
    route_table_id         = aws_route_table.example-rt2.id
    destination_cidr_block = var.vpc_cidr1
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

// Corrected Public VPC Peering Routes
resource "aws_route" "public_vpc1_to_vpc2" {
    route_table_id         = aws_route_table.public_rt1.id
    destination_cidr_block = var.vpc_cidr2
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "public_vpc2_to_vpc1" {
    route_table_id         = aws_route_table.public_rt2.id
    destination_cidr_block = var.vpc_cidr1
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_security_group" "vpc1_sg" {
    vpc_id = aws_vpc.example.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp" // Allow SSH
        cidr_blocks = ["0.0.0.0/0"] // Allow SSH from anywhere (use cautiously)
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" // Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "vpc1-security-group"
    }
}

// Security group for VPC 2 (covers both public and private subnets in VPC 2)
resource "aws_security_group" "vpc2_sg" {
    vpc_id = aws_vpc.example2.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp" // Allow SSH
        cidr_blocks = ["0.0.0.0/0"] // Allow SSH from anywhere (use cautiously)
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" // Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "vpc2-security-group"
    }
}
resource "aws_instance" "example-instance1" {
    ami           = var.ami_id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.example-sn1.id
    vpc_security_group_ids = [aws_security_group.vpc1_sg.id]
    key_name = "k8s"

    tags = {
        Name = "public-instance-1"
    }

}

resource "aws_instance" "example-instance2" {
    ami           = var.ami_id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.example-sn2.id
    vpc_security_group_ids = [aws_security_group.vpc2_sg.id]
    key_name = "k8s"

    tags = {
        Name = "public-instance-2"
    }
}

resource "aws_instance" "example-instance3" {
    ami           = var.ami_id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.private-sn2.id
    vpc_security_group_ids = [aws_security_group.vpc2_sg.id]
    key_name = "k8s"

    tags = {
        Name = "private-instance-1"
    }
}

resource "aws_instance" "example-instance4" {
    ami           = var.ami_id
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.private-sn2.id
    vpc_security_group_ids = [aws_security_group.vpc2_sg.id]
    key_name = "k8s"

    tags = {
        Name = "private-instance-2"
    }
}
