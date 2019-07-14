data "aws_iam_policy_document" "eks_winebarrel_ng_node_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_winebarrel_ng_node_instance" {
  name               = "eks-winebarrel-ng-node-instance"
  assume_role_policy = data.aws_iam_policy_document.eks_winebarrel_ng_node_instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "eks_winebarrel_ng_node_instance" {
  name = "eks-winebarrel-ng-node-instance"
  role = aws_iam_role.eks_winebarrel_ng_node_instance.name
}

resource "aws_iam_role_policy_attachment" "eks_winebarrel_ng_node_instance" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    aws_iam_policy.kube2iam.arn,
  ])

  role       = aws_iam_role.eks_winebarrel_ng_node_instance.name
  policy_arn = each.key
}

