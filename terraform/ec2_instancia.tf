data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 
}

resource "aws_instance" "webgoat_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo apt-get update -y
                  sudo apt-get install docker.io -y
                  sudo systemctl enable docker
                  aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin ${aws_ecr_repository.webgoat_repo.repository_url}
                  sudo docker pull ${aws_ecr_repository.webgoat_repo.repository_url}:latest
                  sudo docker run -d -p 8080:8080 -p 9090:9090 ${aws_ecr_repository.webgoat_repo.repository_url}:latest
                  EOF
  vpc_security_group_ids = [aws_security_group.webgoat_sg.id]
  tags = {
    Name = "WebGoat-Server"
  }
}

# Grupo de Seguridad
resource "aws_security_group" "webgoat_sg" {
  name        = "webgoat-security-group"
  description = "Permite tráfico HTTP, HTTPS, WebGoat (8080) y WebWolf (9090)"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}