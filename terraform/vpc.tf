/*
*      VPC, Subnet, Route Table, IGW, NAT, and Security Group creation
*/

# VPC Resource
resource "aws_vpc" "project_3_vpc" {
  cidr_block                = "10.0.0.0/16"
  enable_dns_hostnames      = true

  tags = {
      Name = "group-project-3-vpc"
  }
}
# Public App Subnet Resource
resource "aws_subnet" "app_subnet" {
  vpc_id                    = aws_vpc.project_3_vpc.id
  cidr_block                = "10.0.0.0/20"
  map_public_ip_on_launch   = true
  availability_zone         = data.aws_availability_zones.available.names[1]


  tags = {
      Name = "group-project-3-app_subnet"
  }
}

data "aws_availability_zones" "available" {
  state                     = "available"
}

# Public DB Subnet Resource
resource "aws_subnet" "db_subnet" {
  vpc_id                    = aws_vpc.project_3_vpc.id
  cidr_block                = "10.0.128.0/20"
  availability_zone         = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch   = true

  tags = {
      Name = "group-project-3-db_subnet"
  }
}

# Resource for Internet Gateway for Public Subnet
resource "aws_internet_gateway" "group-project-3-main_igw" {
  vpc_id                    = aws_vpc.project_3_vpc.id

  tags = {
      Name = "group-project-3-main_igw"
  }
}
# Elastic IP for NAT Gateway for Private Subnet
resource "aws_eip" "group-project-3-nat_eip" {
  vpc                       = true
  depends_on                = [aws_internet_gateway.group-project-3-main_igw]

  tags = {
      Name = "group-project-3-nat_eip"
  }
}

# NAT Gateway for VPC
resource "aws_nat_gateway" "group-project-3-nat" {
  allocation_id             = aws_eip.group-project-3-nat_eip.id
  subnet_id                 = aws_subnet.app_subnet.id

  tags = {
      Name = "group-project-3-nat"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id                    = aws_vpc.project_3_vpc.id

  route {
    cidr_block              = "0.0.0.0/0"
    gateway_id              = aws_internet_gateway.group-project-3-main_igw.id
  }

  tags = {
      Name = "group-project-3-public_route_table"
  }    
}

# Association between Public App Subnet and Public Route Table
resource "aws_route_table_association" "app_subnet" {
  subnet_id                 = aws_subnet.app_subnet.id
  route_table_id            = aws_route_table.public.id
}

# Association between Public Db Subnet and Public Route Table
resource "aws_route_table_association" "db_subnet" {
  subnet_id                 = aws_subnet.db_subnet.id
  route_table_id            = aws_route_table.public.id
}

# Compute Security Group
# resource "aws_security_group" "ec2_sg" {
#   name                      = "ec2_security_group"
#   description               = "Security Group for EC2 webserver instance for SSH and HTTP/HTTPS traffic"
#   vpc_id                    = aws_vpc.project_3_vpc.id

#   ingress {
#     from_port               = 22
#     to_port                 = 22
#     protocol                = "tcp"
#     cidr_blocks             = ["10.0.0.0/18", "0.0.0.0/0"]
#   }
  
#   ingress {
#     from_port               = 3000
#     to_port                 = 3000
#     protocol                = "tcp"
#     cidr_blocks             = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port               = 443
#     to_port                 = 443
#     protocol                = "tcp"
#     cidr_blocks             = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port               = 0
#     to_port                 = 0
#     protocol                = "-1"
#     cidr_blocks             = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "EC2 Security Group"
#     security_group = "ec2_sg"
#   }
# }

# RDS Security Group
resource "aws_security_group" "db_sg" {
  name                      = "db_security_group"
  description               = "DB security group for RDS and SSH traffic over ports 3306 and 22"
  vpc_id                    = aws_vpc.project_3_vpc.id
  
  ingress {
    from_port               = 3306
    to_port                 = 3306
    protocol                = "tcp"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  egress {
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
    security_group = "rds_sg"
  }
}