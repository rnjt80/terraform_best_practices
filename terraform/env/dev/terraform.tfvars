dev_vpc_cidr       = "10.0.0.0/16"
dev_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
dev_private_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
dev_availability_zones = ["us-east-1a", "us-east-1b"] # Replace with your AZs
dev_ami_id           = "ami-xxxxxxxxxxxxxxxxx"
dev_instance_type    = "t3.micro"
dev_instance_count    = 1