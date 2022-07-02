#!/usr/bin/env bash
yum install -y docker git
systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

git clone https://github.com/vladyslav-tripatkhi/hillel_jenkins.git
chown -r ec2-user:ec2-user ./hillel_jenkins
cd hillel_jenkins && docker-compose build && docker-compose up -d

