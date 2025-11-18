provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "practice_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "practice-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_2a" {
  vpc_id                  = aws_vpc.practice_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "practice-sub-pub-2a"
  }
}

resource "aws_subnet" "public_2c" {
  vpc_id                  = aws_vpc.practice_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "practice-sub-pub-2c"
  }
}


# Private Subnets
resource "aws_subnet" "private_2a" {
  vpc_id            = aws_vpc.practice_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "practice-sub-pri-2a"
  }
}

resource "aws_subnet" "private_2c" {
  vpc_id            = aws_vpc.practice_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "practice-sub-pri-2c"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "practice_igw" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "practice-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "practice_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "practice-nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "practice_nat_2a" {
  allocation_id = aws_eip.practice_nat_eip.id
  subnet_id     = aws_subnet.public_2a.id

  tags = {
    Name = "practice-nat-2a"
  }
}


# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "practice-rt-public"
  }
}

# Public Route: 0.0.0.0/0 → Internet Gateway
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.practice_igw.id
}

# Public Route Table Associations (2a, 2c)
resource "aws_route_table_association" "public_2a_assoc" {
  subnet_id      = aws_subnet.public_2a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2c_assoc" {
  subnet_id      = aws_subnet.public_2c.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.practice_vpc.id

  tags = {
    Name = "practice-rt-private"
  }
}

# Private Route: 0.0.0.0/0 → NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.practice_nat_2a.id
}

# Private Route Table Associations (2a, 2c)
resource "aws_route_table_association" "private_2a_assoc" {
  subnet_id      = aws_subnet.private_2a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_2c_assoc" {
  subnet_id      = aws_subnet.private_2c.id
  route_table_id = aws_route_table.private_rt.id
}
