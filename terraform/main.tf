# Stretch goal: provision one free-tier EC2 instance that runs the Docker Compose stack.
# Credentials come from your AWS CLI profile or environment variables - never commit them.

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_security_group" "web" {
  name_prefix = "containerised-app-"
  description = "Allow HTTP to the Nginx container"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_http_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOT
    #!/bin/bash
    set -eux
    dnf install -y docker git
    systemctl enable --now docker
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    git clone ${var.repo_url} /opt/app
    cd /opt/app
    sed -i 's/"8080:80"/"80:80"/' docker-compose.yml
    docker compose up -d --build
  EOT

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name    = "containerised-app-cicd"
    Project = "freelancing-lab"
  }
}
