output "vpc_id" {
    value = aws_vpc.main.id
}

output "instance_id" {
    value = aws_instance.webserver.id 
}

output "instance_public_ip" {
    value = aws_instance.webserver.public_ip
}

output "instance_private_ip" {
    value = aws_instance.webserver.private_ip
}

output "public_subnet_ids" {
  value = aws_subnet.private_subnet.id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.id
}
