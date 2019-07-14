resource "aws_security_group" "eks_winebarrel_alb_ingress" {
  name   = "eks-winebarrel-alb-ingress"
  vpc_id = data.aws_vpc.sandbox3.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-winebarrel-alb-ingress"
  }
}

data "aws_security_group" "cluster_shared_node" {
  vpc_id = data.aws_vpc.sandbox3.id

  filter {
    name   = "group-name"
    values = ["eksctl-winebarrel-cluster-ClusterSharedNodeSecurityGroup-*"]
  }
}

resource "aws_security_group_rule" "cluster_shared_node_allow_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  description              = "Allow worker nodes to ALB Ingress"
  security_group_id        = data.aws_security_group.cluster_shared_node.id
  source_security_group_id = aws_security_group.eks_winebarrel_alb_ingress.id
}
