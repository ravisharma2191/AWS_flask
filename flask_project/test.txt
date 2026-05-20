provider "aws" {
  region = "us-east-1"
}

# Existing VPC
data "aws_vpc" "ravi_vpc_01" {
  id = "vpc-0a2a7facd166a2f36"
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.ravi_vpc_01.id
  cidr_block              = "10.0.1.0/16"
  map_public_ip_on_launch = true

  tags = {
    Name = "ravi_subnet_03"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.ravi_vpc_01.id

  tags = {
    Name = "ravi_internet_gateway_02"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.ravi_vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ravi_route21"
  }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "app_sg" {
  name   = "ravi_inbound_1"
  vpc_id = data.aws_vpc.ravi_vpc_01.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "single_ec2" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "ravi_ec2"
  }
}