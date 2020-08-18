terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "dpag"
  region  = "ap-northeast-2"
}

resource "aws_vpc" "vpc_devops" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "DD group vpc"
  }
}

resource "aws_subnet" "DD_group_dev_pub" {
  cidr_block        = "172.16.0.0/24"
  vpc_id            = aws_vpc.vpc_devops.id
  availability_zone = "ap-northeast-2"
  tags = {
    Name = "DD group public subnet"
  }
}

resource "aws_network_interface" "DD_nic" {
  subnet_id   = aws_subnet.DD_group_dev_pub.id
  private_ips = ["172.16.10.100"]
}

resource "aws_instance" "dm_docker_test" {
  ami           = "ami-05a4cce8936a89f06"
  instance_type = "t2.micro"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.DD_nic.id
  }

  tags = {
    Name        = "t1111587"
    Description = "DM team test"
  }
}
