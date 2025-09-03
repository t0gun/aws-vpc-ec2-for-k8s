provider "aws" {
  region = var.region
}



################ DEFINE VPC AND SUBNETS
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "private-subnet"
  }
}


######## CREATE INTERNET GATEWAY AND NAT GATEWAY
# Nat allows our private subnets to reach the internet
# the igw allows resources in the vpc with a public ip to reach the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "k8s-igw"
  }
}
# Nat gw needs public ip
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id   # id of elastic ip
  subnet_id     = aws_subnet.public.id # nats get a private ip too from subnet CIDR block
  tags = {
    Name = "k8s-nat"
  }
}

### Routing
resource "aws_route_table" "public" {
  vpc_id =  aws_vpc.main.id
  route {
    # route all web traffic to internet gateway, since nat is in this subnet it gets internet access too
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.9/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

# associating subnets with route tables
resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.private.id
}



