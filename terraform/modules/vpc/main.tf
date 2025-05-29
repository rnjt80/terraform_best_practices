resource "aws_vpc" "main" {
    cidr_block           = var.cidr_block
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support   = var.enable_dns_support

    tags = {
        Name = "${var.environment_name}-vpc"
    }
}

resource "aws_subnet" "public" {
    count             = length(var.public_subnets)
    vpc_id            = aws_vpc.main.id
    cidr_block        = element(var.public_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.environment_name}-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private" {
    count             = length(var.private_subnets)
    vpc_id            = aws_vpc.main.id
    cidr_block        = element(var.private_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)

    tags = {
        Name = "${var.environment_name}-private-subnet-${count.index + 1}"
    }
}

resource "aws_internet_gateway" "igw" {
    count = var.enable_nat_gateway ? 1 : 0
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.environment_name}-igw"
    }
}

resource "aws_eip" "nat" {
    count    = var.enable_nat_gateway && var.single_nat_gateway ? 1 : 0
    domain   = "vpc"
    depends_on = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.environment_name}-nat-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    count         = var.enable_nat_gateway ? length(var.public_subnets) : 0
    allocation_id = var.single_nat_gateway ? aws_eip.nat[0].id : aws_eip.nat[count.index].id
    subnet_id     = aws_subnet.public[count.index].id
    depends_on    = [aws_internet_gateway.igw]

    tags = {
        Name = "${var.environment_name}-nat-gateway-${count.index + 1}"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw[0].id
    }

    tags = {
        Name = "${var.environment_name}-public-rt"
    }
}

resource "aws_route_table_association" "public" {
    count          = length(aws_subnet.public)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    count    = var.enable_nat_gateway ? length(var.private_subnets) : length(var.private_subnets)
    vpc_id   = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = var.enable_nat_gateway ? aws_nat_gateway.nat[count.index].id : null
    }

    tags = {
        Name = "${var.environment_name}-private-rt-${count.index + 1}"
    }
}

resource "aws_route_table_association" "private" {
    count          = length(aws_subnet.private)
    subnet_id      = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id
}

resource "aws_security_group" "default" {
    name_prefix = "${var.environment_name}-default-sg-"
    vpc_id      = aws_vpc.main.id

    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [aws_vpc.main.cidr_block] # Allow all traffic within the VPC
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
    }

    tags = {
        Name = "${var.environment_name}-default-sg"
    }
}