data "aws_vpc" "sandbox3" {
  id = "vpc-042e19e98db2fc229"
}

resource "aws_subnet" "sandbox3_public_az_b" {
  vpc_id     = data.aws_vpc.sandbox3.id
  cidr_block = "10.3.0.0/24"

  tags = {
    Name                               = "sandbox3 public subnet az-b"
    "kubernetes.io/cluster/winebarrel" = "shared"

    # for AWS ALB Ingress Controller
    "kubernetes.io/role/elb" = ""
  }
}

resource "aws_subnet" "sandbox3_public_az_c" {
  vpc_id     = data.aws_vpc.sandbox3.id
  cidr_block = "10.3.2.0/24"

  tags = {
    Name                               = "sandbox3 public subnet az-c"
    "kubernetes.io/cluster/winebarrel" = "shared"

    # for AWS ALB Ingress Controller
    "kubernetes.io/role/elb" = ""
  }
}
