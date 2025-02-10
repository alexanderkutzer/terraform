# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-156498562"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
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
    security_groups = [aws_security_group.my-sg.name]

    tags = {
        name = "alexanders terraform"
    }
}
