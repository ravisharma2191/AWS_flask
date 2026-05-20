provider "aws" {
  region = "us-east-1"
}

########################
# VARIABLES
########################

variable "vpc_id" {
  default = "vpc-0a2a7facd166a2f36"
}

variable "subnet_id" {
  default = "subnet-08d813a8e991ed72e"
}

variable "security_group_id" {
  default = "sg-02213b04ec685f006"
}


########################
# ROUTE TABLE
########################

resource "aws_route_table" "ravi_route2" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-023864376d041778f"
  }

  tags = {
    Name = "ravi_route2"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.ravi_route2.id
}

########################
# UBUNTU AMI
########################

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

########################
# EC2 INSTANCE
########################

resource "aws_instance" "EC2_RAVI" {

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              apt update -y

              #################################
              # Install Python & Flask
              #################################

              apt install -y python3-pip

              pip3 install flask

              #################################
              # Install Node.js
              #################################

              curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

              apt install -y nodejs

              #################################
              # Flask App
              #################################

              mkdir -p /home/ubuntu/flask-app

              cat <<EOT > /home/ubuntu/flask-app/app.py
from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Flask Backend Running"
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOT

              nohup python3 /home/ubuntu/flask-app/app.py > /home/ubuntu/flask.log 2>&1 &

              #################################
              # Express App
              #################################

              mkdir -p /home/ubuntu/express-app

              cd /home/ubuntu/express-app

              npm init -y

              npm install express

              cat <<EOT > /home/ubuntu/express-app/server.js
const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send('Express Frontend Running');
});

app.listen(3000, '0.0.0.0', () => {
  console.log('Express server running');
});
EOT

              nohup node /home/ubuntu/express-app/server.js > /home/ubuntu/express.log 2>&1 &

              EOF

  tags = {
    Name = "Ravi-Ubuntu-Server"
  }
}

########################
# OUTPUT
########################

output "instance_public_ip" {
  value = aws_instance.EC2_RAVI.public_ip
}