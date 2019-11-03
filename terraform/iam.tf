resource "aws_iam_openid_connect_provider" "iamserviceaccount" {
  url             = "https://oidc.eks.ap-northeast-1.amazonaws.com/id/7B3563298B272AD3931E50C1A5E17831"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}

/*
module "kube_external_secrets_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.iamserviceaccount

  serviceaccount = {
    namespace = "kubernetes-external-secrets"
    name      = "kubernetes-external-secrets-service-account"
  }
}
*/

# cf. https://github.com/jtblin/kube2iam#iam-roles
data "aws_iam_policy_document" "kube2iam_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "kube2iam" {
  name        = "kube2iam"
  path        = "/"
  description = "kube2iam"
  policy      = data.aws_iam_policy_document.kube2iam_policy.json
}

data "aws_iam_policy_document" "nodegroup_winebarrel_ng_workers_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "nodegroup_winebarrel_ng_workers" {
  name               = "nodegroup-winebarrel-ng-workers"
  assume_role_policy = data.aws_iam_policy_document.nodegroup_winebarrel_ng_workers_assume_role_policy.json
}

resource "aws_iam_instance_profile" "nodegroup_winebarrel_ng_workers" {
  name = "nodegroup-winebarrel-ng-workers"
  role = aws_iam_role.nodegroup_winebarrel_ng_workers.name
}

resource "aws_iam_role_policy_attachment" "nodegroup_winebarrel_ng_workers" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    aws_iam_policy.kube2iam.arn,
  ])

  role       = aws_iam_role.nodegroup_winebarrel_ng_workers.name
  policy_arn = each.key
}

data "aws_iam_policy_document" "kube2iam_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"

      identifiers = [
        aws_iam_role.nodegroup_winebarrel_ng_workers.arn,
      ]
    }
  }
}

resource "aws_iam_role" "kube_external_secrets" {
  name = "kube-external-secrets"
  #assume_role_policy = module.kube_external_secrets_iamserviceaccount.assume_role_policy.json
  assume_role_policy = data.aws_iam_policy_document.kube2iam_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "kube_external_secrets_amazon_ssm_read_only_access" {
  role       = aws_iam_role.kube_external_secrets.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

module "kube_external_dns_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.iamserviceaccount

  serviceaccount = {
    namespace = "kube-system"
    name      = "external-dns"
  }
}

resource "aws_iam_role" "kube_external_dns" {
  name               = "kube-external-dns"
  assume_role_policy = module.kube_external_dns_iamserviceaccount.assume_role_policy.json
}

data "aws_iam_policy_document" "kube_external_dns_policy" {
  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${data.aws_route53_zone.winebarrel_work.zone_id}",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "kube_external_dns" {
  name        = "kube-external-dns"
  path        = "/"
  description = "kube-external-dns policy"
  policy      = data.aws_iam_policy_document.kube_external_dns_policy.json
}

resource "aws_iam_role_policy_attachment" "kube_external_dns" {
  role       = aws_iam_role.kube_external_dns.name
  policy_arn = aws_iam_policy.kube_external_dns.arn
}


module "aws_alb_ingress_controller_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.iamserviceaccount

  serviceaccount = {
    namespace = "kube-system"
    name      = "alb-ingress"
  }
}

resource "aws_iam_role" "aws_alb_ingress_controller" {
  name               = "aws-alb-ingress-controller"
  assume_role_policy = module.aws_alb_ingress_controller_iamserviceaccount.assume_role_policy.json
}

# cf. https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.0.0/docs/examples/iam-policy.json
data "aws_iam_policy_document" "aws_alb_ingress_controller_policy" {
  statement {
    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "elasticloadbalancing:DescribeListenerCertificates",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "tag:GetResources",
      "tag:TagResources",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "waf:GetWebACL",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "aws_alb_ingress_controller" {
  name        = "AWSALBIngressController"
  description = "aws-alb-ingress-controller policy"
  policy      = data.aws_iam_policy_document.aws_alb_ingress_controller_policy.json
}

resource "aws_iam_role_policy_attachment" "aws_alb_ingress_controller" {
  role       = aws_iam_role.aws_alb_ingress_controller.name
  policy_arn = aws_iam_policy.aws_alb_ingress_controller.arn
}

/*
module "cluster_autoscaler_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.iamserviceaccount

  serviceaccount = {
    namespace = "kube-system"
    name      = "cluster-autoscaler"
  }
}
*/

resource "aws_iam_role" "cluster_autoscaler" {
  name = "cluster-autoscaler"
  #assume_role_policy = module.cluster_autoscaler_iamserviceaccount.assume_role_policy.json
  assume_role_policy = data.aws_iam_policy_document.kube2iam_assume_role_policy.json
}

# cf.
# - https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md#attach-iam-policy-to-nodegroup
# - https://aws.amazon.com/jp/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
data "aws_iam_policy_document" "cluster_autoscaler_policy" {
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

resource "aws_iam_policy" "cluster_autoscaler" {
  name   = "cluster-autoscaler"
  policy = data.aws_iam_policy_document.cluster_autoscaler_policy.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}
