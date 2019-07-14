module "cluster_autoscaler_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.eks_winebarrel_iamserviceaccount

  serviceaccount = {
    namespace = "kube-system"
    name      = "cluster-autoscaler"
  }
}

resource "aws_iam_role" "kube_cluster_autoscaler" {
  name               = "kube-cluster-autoscaler"
  assume_role_policy = module.cluster_autoscaler_iamserviceaccount.assume_role_policy.json
}

# cf.
# - https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#attach-iam-policy-to-nodegroup
# - https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
data "aws_iam_policy_document" "kube_cluster_autoscaler_policy" {
  statement {
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "kube_cluster_autoscaler" {
  name   = "kube-cluster-autoscaler"
  policy = data.aws_iam_policy_document.kube_cluster_autoscaler_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.kube_cluster_autoscaler.name
  policy_arn = aws_iam_policy.kube_cluster_autoscaler.arn
}
