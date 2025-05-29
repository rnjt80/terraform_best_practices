module "dev_ec2_instance" {
    source  = "../../modules/ec2"
    environment_name    = "dev"
    instance_count      = var.dev_instance_count
    ami                 = var.dev_ami_id # Replace with your dev AMI ID
    instance_type       = var.dev_instance_type
    subnet_id           = element(module.dev_vpc.public_subnet_ids, 0)
    security_group_ids  = [module.dev_vpc.default_security_group_id]
    key_name            = "your-dev-key-pair"
    associate_public_ip = true
    user_data           = <<-EOF
    #!/bin/bash
    echo "Hello, Dev!" > /tmp/dev.txt
    EOF

    tags = {
        Environment = "dev"
    }
}