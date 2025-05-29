output "instance_ids" {
    value       = aws_instance.server.*.id
    description = "List of IDs of the EC2 instances"
}

output "public_ips" {
    value       = aws_instance.server.*.public_ip
    description = "List of public IP addresses of the EC2 instances"
}

output "private_ips" {
    value       = aws_instance.server.*.private_ip
    description = "List of private IP addresses of the EC2 instances"
}