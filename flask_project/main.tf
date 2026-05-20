provider "aws" {
  region = "ap-south-1"
}

# Existing VPC
variable "vpc_id" {
  default = "vpc-0a2a7facd166a2f36"
}

# Existing Public Subnet
variable "subnet_id" {
  default = "subnet-08d813a8e991ed72e"
}

# Existing Security Group
variable "security_group_id" {
  default = "sg-02213b04ec685f006"
}

# Key Pair
variable "key_name" {
  description = "EC2 Key Pair"
  type        = string
}

# Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "EC2_RAVI" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Ravi-Ubuntu-Server"
  }
}

# Output
output "instance_public_ip" {
  value = aws_instance.EC2_RAVI.public_ip
}