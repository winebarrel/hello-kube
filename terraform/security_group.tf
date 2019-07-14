resource "aws_security_group" "control_plane" {
  vpc_id      = data.aws_vpc.sandbox3.id
  name        = "eks-winebarrel-control-plane"
  description = "Communication between the control plane and worker nodegroups"

  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = {
    Name = "eks-winebarrel-control-plane"
  }
}

// NOTE: Created by EKS
data "aws_security_group" "eks_cluster_winebarrel" {
  filter {
    name   = "group-name"
    values = ["eks-cluster-sg-winebarrel-*"]
  }
}

resource "aws_security_group_rule" "eks_cluster_winebarrel_allow_eks_winebarrel_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  description              = "Allow worker nodes from ALB Ingress"
  security_group_id        = data.aws_security_group.eks_cluster_winebarrel.id
  source_security_group_id = aws_security_group.eks_winebarrel_alb_ingress.id
}

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
