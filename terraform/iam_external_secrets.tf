module "kube_external_secrets_iamserviceaccount" {
  source                  = "./modules/iamserviceaccount"
  openid_connect_provider = aws_iam_openid_connect_provider.eks_winebarrel_iamserviceaccount

  serviceaccount = {
    namespace = "kubernetes-external-secrets"
    name      = "kubernetes-external-secrets-service-account"
  }
}

resource "aws_iam_role" "kube_external_secrets" {
  name               = "kube-external-secrets"
  assume_role_policy = module.kube_external_secrets_iamserviceaccount.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "kube_external_secrets_amazon_ssm_read_only_access" {
  role       = aws_iam_role.kube_external_secrets.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
