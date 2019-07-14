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
        aws_iam_role.eks_winebarrel_ng_node_instance.arn,
      ]
    }
  }
}
