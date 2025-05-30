prod_vpc_cidr       = "172.16.0.0/16"
prod_public_subnets   = ["172.16.1.0/24", "172.16.2.0/24"]
prod_private_subnets  = ["172.16.101.0/24", "172.16.102.0/24"]
prod_availability_zones = ["us-east-1a", "us-east-1b"]
prod_ami_id           = "ami-yyyyyyyyyyyyyyyyy"
prod_instance_type    = "t3.medium"
prod_instance_count    = 3
prod_root_block_device = {
    volume_size = 20
    volume_type = "gp3"
    encrypted = true
  }

prod_ebs_block_devices = [
    {
      device_name = "/dev/sdh"
      volume_size = 100
      volume_type = "gp3"
      encrypted = true
    },
  ]