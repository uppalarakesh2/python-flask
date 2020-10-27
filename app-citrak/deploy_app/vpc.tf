# vpc.tf
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "Prod VPC"
  }
}
# create the Subnet
resource "aws_subnet" "Prod_Public_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.publicsubnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
  tags = {
    Name = "PublicSubnet"
  }
}
resource "aws_subnet" "Prod_Public_Subnet2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.publicsubnetCIDR2block
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone2
  tags = {
    Name = "PublicSubnet"
  }
}
resource "aws_subnet" "Prod_Private_Subnet1" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.private1subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
  tags = {
    Name = "PrivateSubnet1"
  }
}
resource "aws_subnet" "Prod_Private_Subnet2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.private2subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone2
  tags = {
    Name = "PrivateSubnet2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "prod_vpc_igw" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
    Name = "Prod_igw"
  }
}

# Route table: attach Internet Gateway
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.My_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_vpc_igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}
# Route table Assosiation
resource "aws_route_table_association" "ProdPublicSubnet1Routetable" {
    subnet_id = aws_subnet.Prod_Public_Subnet.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "ProdPublicSubnet2Routetable" {
    subnet_id = aws_subnet.Prod_Public_Subnet2.id
    route_table_id = aws_route_table.public_rt.id
}
# cretae eip
resource "aws_eip" "nat_ip" {
  vpc = true
  tags = {
    Name      = "nat_ip"
  }
}

# create nat
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.Prod_Public_Subnet.id
}


#attach nat
resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.My_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Subnet1"
  }
}


#Associate Nat
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private1.id
  subnet_id      = aws_subnet.Prod_Private_Subnet1.id
}
resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private1.id
  subnet_id      = aws_subnet.Prod_Private_Subnet2.id
}
# Create the Security Group
resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "My VPC Security Group"
  description = "My VPC Security Group"

  # allow ingress of port 22
  ingress {
      from_port = "5000"
      to_port   = "5000"
      protocol  = "tcp"

      security_groups = [
        aws_security_group.lb_Security_Group.id,
      ]
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "My VPC Security Group"
    Description = "My VPC Security Group"
  }
}

resource "aws_security_group" "lb_Security_Group" {
  vpc_id      = aws_vpc.My_VPC.id
  name        = "LB Security Group"
  description = "LB Security Group"

  # allow ingress of port 80
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "My VPC Security Group"
    Description = "My VPC Security Group"
  }
}
