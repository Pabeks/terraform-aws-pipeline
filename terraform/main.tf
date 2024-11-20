provider "aws" {
    region = "us-east-1" 
}

locals {
    setup_name = "wordpress"
}

data "aws_ami" "Ubuntu_Pro_Linux" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu-pro-server/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-pro-server-20240913"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_key_pair" "wordpress_key" {
  key_name   = "wordpress_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "wordpress_key" {
    content     = tls_private_key.rsa.private_key_pem 
    filename = "/tmp/wordpress_key.txt" 
}

# Create a VPC
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true
    
    tags = {
      Name = "${local.setup_name}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "${local.setup_name}-igw"
    }
}

# Create a Route Table with a route to the Internet Gateway
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.main.id
    
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the Route Table with a Subnet. but create subnet first

resource "aws_subnet" "public_subnet" {  
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr

    tags = {
        Name = "${local.setup_name}-public_subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr

    tags = {
        Name = "${local.setup_name}-private_subnet"
    }
}

resource "aws_route_table_association" "public_route" {
    route_table_id = aws_route_table.public_route.id
    subnet_id = aws_subnet.public_subnet.id
}

resource "aws_security_group" "wordpressSG" {
  name = "allow all web traffic"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  tags = {
    Name = "${local.setup_name}-security_group"
  }
}

resource "aws_instance" "webserver" {
    ami = data.aws_ami.Ubuntu_Pro_Linux.id
    instance_type = var.instance_type
    associate_public_ip_address = true
    subnet_id = aws_subnet.public_subnet.id
    security_groups = [aws_security_group.wordpressSG.id]
    key_name = "wordpress_key"

    tags = {
        Name = "${local.setup_name}-server"
    }
}