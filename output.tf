output "public_ip" {
 value       = aws_instance.public_instance.public_ip
 description = "Public IP Address of EC2 instance"
}

output "instance_id" {
 value       = aws_instance.public_instance.id
 description = "Instance ID"
}

output "public_subnet_1_id" {
  value       = aws_subnet.public-subnet-1.id
  description = "ID of public subnet 1"
}

output "public_subnet_2_id" {
  value       = aws_subnet.public-subnet-2.id
  description = "ID of public subnet 2"
}

output "public_subnet_3_id" {
  value       = aws_subnet.public-subnet-3.id
  description = "ID of public subnet 3"
}

output "public_subnet_cidrs" {
  value = [
    aws_subnet.public-subnet-1.cidr_block,
    aws_subnet.public-subnet-2.cidr_block,
    aws_subnet.public-subnet-3.cidr_block
  ]
  description = "CIDR blocks of all public subnets"
}