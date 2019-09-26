# Define our VPC
resource "aws_vpc" "tf-eks-PF" {
  cidr_block = "${var.vpc_cidr_server}"
  enable_dns_hostnames = true

  tags = {
    Name = "SECURE-VPC-${var.name_of_user}"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet-server" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"
  cidr_block = "${var.public_subnet_cidr_server}"
  availability_zone = "${var.aws_region_server}a"

  tags = "${
    map (
        "Name", "Public Subnet Server-${var.name_of_user}",
        "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}


# Define the private subnet
resource "aws_subnet" "private-subnet-server" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"
  cidr_block = "${var.private_subnet_cidr_server}"
  availability_zone = "${var.aws_region_server}b"

  tags = {
    Name = "Private Subnet Server-${var.name_of_user}"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw-s" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"

  tags = {
    Name = "VPC IGW-${var.name_of_user}"
  }
}

#Private Subnet EIP for NAT Gateway
resource "aws_eip" "nat_gw_eip_server" {
  vpc = true

  tags = {
    Name = "Elastic-IP-${var.name_of_user}"
  }
}

#Private Subnet Nat Gateway
resource "aws_nat_gateway" "nat_gw_server_private" {
  allocation_id = "${aws_eip.nat_gw_eip_server.id}"
  subnet_id     = "${aws_subnet.public-subnet-server.id}"

  tags = {
    Name = "NAT Gateway-${var.name_of_user}"
  }
}

# Define the public route table 
resource "aws_route_table" "public-rt-s" {
  vpc_id = "${aws_vpc.tf-eks-PF.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw-s.id}"
  }

  tags = {
    Name = "Public Subnet RT-${var.name_of_user}"
  }
}

# Define the private route table
resource "aws_route_table" "private-rt-s" {
    vpc_id = "${aws_vpc.tf-eks-PF.id}"

    tags = {
        Name = "Main Route Table for Private subnet Server-${var.name_of_user}"
    }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt-s" {
  subnet_id = "${aws_subnet.public-subnet-server.id}"
  route_table_id = "${aws_route_table.public-rt-s.id}"
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "private-rt-s" {
  subnet_id = "${aws_subnet.private-subnet-server.id}"
  route_table_id = "${aws_route_table.private-rt-s.id}"
}

# Assign Route for NAT Gateway
resource "aws_route" "private_nat_gateway_route_server" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = "${aws_route_table.private-rt-s.id}"
  depends_on = ["aws_route_table.private-rt-s"]
  nat_gateway_id = "${aws_nat_gateway.nat_gw_server_private.id}"
}


#DHCP Options

resource "aws_vpc_dhcp_options_association" "main_dhcp_association" {
    vpc_id = "${aws_vpc.tf-eks-PF.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.main_dns.id}"
}

resource "aws_vpc_dhcp_options" "main_dns" {
    domain_name = "${var.dns_zone_name}"
    domain_name_servers  = ["${var.dns_route53_ip}"]
#    ntp_servers          = ["${var.dns_route53_ip}"]
#    netbios_name_servers = ["${var.dns_route53_ip}"]
#    netbios_node_type    = 2
}
