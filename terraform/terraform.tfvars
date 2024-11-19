instance_type = "t2.micro"

vpc_cidr = "10.0.0.0/16"

aws_region = "us-east-1"

private_subnet_cidr =  "10.0.0.0/24"

public_subnet_cidr = "10.0.1.0/24"

ingress = [ 22, 80, 443 ]

egress = [ 22, 80, 443 ]

home_directory = "/Users/paulabekah"