module "kube_external_dns_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.eks_winebarrel_iamserviceaccount

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

