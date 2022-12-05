# VPC Resource
resource "aws_vpc" "project_3_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "group-project-3-vpc terraform"
  }
}

# Public Subnet Resource
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.project_3_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]


  tags = {
    Name = "group-project-3-public_subnet terraform"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnet2 Resource
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.project_3_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "group-project-3-public2_subnet terraform"
  }
}

# Private Subnet Resource for DB instance
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.project_3_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "group-project-3-private_subnet terraform"
  }
}

# Resource for Internet Gateway for Public Subnet
resource "aws_internet_gateway" "group-project-3-main_igw" {
  vpc_id = aws_vpc.project_3_vpc.id

  tags = {
    Name = "group-project-3-main_igw terraform"
  }
}
# Elastic IP for NAT Gateway for Private Subnet
resource "aws_eip" "group-project-3-nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.group-project-3-main_igw]

  tags = {
    Name = "group-project-3-nat_eip terraform"
  }
}

# NAT Gateway for VPC
resource "aws_nat_gateway" "group-project-3-nat" {
  allocation_id = aws_eip.group-project-3-nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "group-project-3-nat terraform"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.project_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.group-project-3-main_igw.id
  }

  tags = {
    Name = "group-project-3-public_route_table terraform"
  }
}

# Route Table for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.project_3_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.group-project-3-nat.id
  }

  tags = {
    Name = "group-project-3-private_route_table terraform"
  }
}

# Association between Public Subnet and Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Association between Public2 Subnet and Public Route Table
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# Association between Private Subnet and Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# RDS Security Group
resource "aws_security_group" "db_sg" {
  name        = "db_security_group"
  description = "DB security group for RDS and SSH traffic over ports 3306 and 22"
  vpc_id      = aws_vpc.project_3_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name           = "DB Security Group terraform"
    security_group = "rds_sg"
  }
}