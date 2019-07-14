variable "openid_connect_provider" {
  type = object({
    arn = string
    url = string
  })
}

variable "serviceaccount" {
  type = object({
    namespace = string
    name      = string
  })
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.openid_connect_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.openid_connect_provider.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.openid_connect_provider.url}:sub"
      values   = ["system:serviceaccount:${var.serviceaccount.namespace}:${var.serviceaccount.name}"]
    }
  }
}

output "assume_role_policy" {
  value = data.aws_iam_policy_document.assume_role_policy
}
