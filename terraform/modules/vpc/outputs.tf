output "vpc_id" {
    value       = aws_vpc.main.id
    description = "ID of the VPC"
}

output "public_subnet_ids" {
    value       = aws_subnet.public.*.id
    description = "List of IDs of public subnets"
}

output "private_subnet_ids" {
    value       = aws_subnet.private.*.id
    description = "List of IDs of private subnets"
}

output "default_security_group_id" {
    value       = aws_security_group.default.id
    description = "ID of the default security group for the VPC"
}