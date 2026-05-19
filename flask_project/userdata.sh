#!/bin/bash

yum update -y

# Install Python
yum install python3 -y

# Install Node.js
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Flask App
mkdir -p /home/ec2-user/flask-app

cat <<EOF > /home/ec2-user/flask-app/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Flask Backend Running"

app.run(host='0.0.0.0', port=5000)
EOF

pip3 install flask

nohup python3 /home/ec2-user/flask-app/app.py &

# Express App
mkdir -p /home/ec2-user/express-app

cat <<EOF > /home/ec2-user/express-app/app.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Express Frontend Running');
});

app.listen(3000, '0.0.0.0');
EOF

cd /home/ec2-user/express-app
npm init -y
npm install express

nohup node app.js &