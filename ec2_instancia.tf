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

resource "aws_instance" "labDSO" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt upgrade
              sudo apt-get install curl apt-transport-https ca-certificates software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              sudo apt update
              apt-cache policy docker-ce
              sudo apt install docker-ce
              sudo systemctl status docker
              EOF
    vpc_security_group_ids = [ aws_security_group.LabDSOCapacitacion_Jairo.id ]
  tags = {
    Name = "LabDSOCapacitacion_Jairo"
  }
}

# Grupo de Seguridad
resource "aws_security_group" "LabDSOCapacitacion_Jairo" {
    name = "LabDSOCapacitacion_Terraform"
    description = "Capacitacion de Jairo"
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
  
}