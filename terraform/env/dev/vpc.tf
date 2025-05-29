module "dev_vpc" {
    source  = "../../modules/vpc"
    environment_name = "dev"
    cidr_block       = var.dev_vpc_cidr
    public_subnets   = var.dev_public_subnets
    private_subnets  = var.dev_private_subnets
    availability_zones = var.dev_availability_zones

    enable_nat_gateway   = true
    single_nat_gateway   = true

    tags = {
        Environment = "dev"
    }
}