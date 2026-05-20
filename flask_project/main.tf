provider "aws" {
  region = "ap-south-1"
}

# Existing VPC
variable "vpc_id" {
  default = "vpc-0a2a7facd166a2f36"
}

# Existing Public Subnet
variable "subnet_id" {
  default = "subnet-xxxxxxxx"
}

# Existing Security Group
variable "security_group_id" {
  default = "sg-xxxxxxxx"
}

# Existing Key Pair
variable "key_name" {
  default = "your-keypair-name"
}

# Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  associate_public_ip_address = true

  tags = {
    Name = "Ravi-Web-Server"
  }
}

# Output
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}