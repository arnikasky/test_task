# Define the AWS provider and region
provider "aws" {
  region = "eu-central-1"
}

# Define the VPC
resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "my-project-vpc"
  }
}

# Get a list of availability zones in the specified region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create private subnets
resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = 3

  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.${count.index + 101}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Define the internet gateway for the public subnets
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-project-igw"
  }
}

output "vpc_name" {
  description = "The name of the main VPC"
  value       = aws_vpc.main.tags.Name
}

# Output the names of the private subnets
output "private_subnet_names" {
  description = "A list of the names of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.tags.Name]
}

# Output the names of the public subnets
output "public_subnet_names" {
  description = "A list of the names of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.tags.Name]
}