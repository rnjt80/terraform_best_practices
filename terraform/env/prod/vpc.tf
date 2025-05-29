module "prod_vpc" {
    source  = "../../modules/vpc"
    environment_name = "prod"
    cidr_block       = var.prod_vpc_cidr
    public_subnets   = var.prod_public_subnets
    private_subnets  = var.prod_private_subnets
    availability_zones = var.prod_availability_zones
    enable_nat_gateway   = true
    single_nat_gateway   = false

    tags = {
        Environment = "prod"
    }
}