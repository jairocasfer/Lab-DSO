data "aws_caller_identity" "current" {}

resource "aws_instance" "webgoat_ec2" {
  ami = "ami-0cbbe2c6a1bb2ad63"
  instance_type = "t3.nano"
  security_groups = [ aws_security_group.webgoat_sg ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              yum install -y git

              # Login a ECR
              aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com

              # Descargar y ejecutar la imagen
              docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/webgoat:latest
              docker run -d -p 8080:8080 ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/webgoat:latest
              EOF

  tags = {
    Name = "WebGoat-Instance"
  }
}

resource "aws_security_group" "webgoat_sg" {
  name = "webgoat_sg"
  description = "permitir el puerto 8080"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "instance-profile-capacitacion-jairo-2025"
  role = "capacitacion-jairo-2025"
}