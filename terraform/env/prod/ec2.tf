module "prod_ec2_instance" {
    source  = "../../modules/ec2"
    environment_name    = "prod"
    instance_count      = var.prod_instance_count
    ami                 = var.prod_ami_id  # Replace with your prod AMI
    instance_type       = var.prod_instance_type
    subnet_id           = element(module.prod_vpc.private_subnet_ids, 0)
    security_group_ids  = [module.prod_vpc.default_security_group_id]
    key_name            = "your-prod-key-pair"
    associate_public_ip = false
    user_data           = <<-EOF
#!/bin/bash
echo "Hello, Prod!" > /tmp/prod.txt
EOF
    root_block_device = var.prod_root_block_device

    ebs_block_devices = var.prod_ebs_block_devices

    tags = {
        Environment = "prod"
    }
}