provider "aws" {
  region = "eu-central-1"
}

# Security Group
resource "aws_security_group" "my-sg" {
  name        = "my-security-group"
  description = "Security Group for EC2 instance"

  # Eingehender Verkehr (SSH & HTTP)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ausgehender Verkehr (Alles erlaubt)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# EC2-Instanz

resource "aws_instance" "my-ec2" {
    
    ami = "ami-0764af88874b6b852"   # jeweiliges betriebssystem ID
    instance_type = "t2.micro"
    key_name = aws_key_pair
    security_groups = [aws_security_group.my-sg.name]

    tags = {
        name = "alexanders terraform"
    }
}

#-----------------------------------------------------
# SSH-Keypair
# Erst private key erstellen
resource "tls_private_key" "my_private_key"{
    algorithm ="RSA"
    rsa_bits = 4096
}

# Dann AWS Key pair aus dem public key attribute des private keys: 
resource "aws_key_pair" "my_key_pair"{
    key_name = "ec2-access"
    public_key = tls_private_key.my_private_key.public_key_openssh
}

#---------------------------------------------------

output "instance_ip" {
    value = aws_instance.my-ec2.public_ip
}