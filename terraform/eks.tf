resource "aws_eks_cluster" "winebarrel" {
  name     = "winebarrel"
  version  = "1.14"
  role_arn = aws_iam_role.eks_winebarrel_cluster_service.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access  = true

    public_access_cidrs = [
      "0.0.0.0/0",
    ]

    security_group_ids = [
      aws_security_group.control_plane.id,
    ]

    subnet_ids = [
      aws_subnet.sandbox3_public_az_b.id,
      aws_subnet.sandbox3_public_az_c.id,
      aws_subnet.sandbox3_private_az_b.id,
      aws_subnet.sandbox3_private_az_c.id,
    ]
  }
}

resource "aws_eks_node_group" "winebarrel" {
  cluster_name    = aws_eks_cluster.winebarrel.name
  node_group_name = "winebarrel"
  node_role_arn   = aws_iam_role.eks_winebarrel_ng_node_instance.arn
  subnet_ids = [
    aws_subnet.sandbox3_private_az_b.id,
    aws_subnet.sandbox3_private_az_c.id,
  ]

  instance_types = [
    "t3.small"
  ]

  scaling_config {
    desired_size = 1
    max_size     = 50
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [
      scaling_config.0.desired_size,
    ]
  }
}

resource "aws_iam_openid_connect_provider" "eks_winebarrel_iamserviceaccount" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.winebarrel.identity.0.oidc.0.issuer
}
