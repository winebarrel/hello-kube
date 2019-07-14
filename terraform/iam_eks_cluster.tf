data "aws_iam_policy_document" "eks_winebarrel_cluster_service_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "eks-fargate-pods.amazonaws.com",
        "eks.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "eks_winebarrel_cluster_service" {
  name               = "eks-winebarrel-cluster-service-role"
  assume_role_policy = data.aws_iam_policy_document.eks_winebarrel_cluster_service_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_winebarrel_cluster_service" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ])

  role       = aws_iam_role.eks_winebarrel_cluster_service.name
  policy_arn = each.key
}

data "aws_iam_policy_document" "eks_winebarrel_cluster_cloud_watch_metrics_pilicy" {
  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "eks_winebarrel_cluster_cloud_watch_metrics" {
  name   = "eks-winebarrel-cluster-PolicyCloudWatchMetrics"
  role   = aws_iam_role.eks_winebarrel_cluster_service.id
  policy = data.aws_iam_policy_document.eks_winebarrel_cluster_cloud_watch_metrics_pilicy.json
}

data "aws_iam_policy_document" "eks_winebarrel_cluster_nlb_pilicy" {
  statement {
    actions = [
      "elasticloadbalancing:*",
      "ec2:CreateSecurityGroup",
      "ec2:Describe*",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "eks_winebarrel_cluster_nlb" {
  name   = "eks-winebarrel-cluster-PolicyNLB"
  role   = aws_iam_role.eks_winebarrel_cluster_service.id
  policy = data.aws_iam_policy_document.eks_winebarrel_cluster_nlb_pilicy.json
}
