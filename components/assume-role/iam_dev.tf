data "aws_iam_policy" "dev_policy" {
  provider = aws.dev
  name     = "AdministratorAccess"
}

data "aws_iam_policy_document" "dev_assume_role" {
  provider = aws.dev
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.build_account_id}:root"]
    }
  }
}

resource "aws_iam_role" "dev_assume_role" {
  provider            = aws.dev
  name                = "provision_role"
  assume_role_policy  = data.aws_iam_policy_document.dev_assume_role.json
  managed_policy_arns = [data.aws_iam_policy.dev_policy.arn]
  tags                = {}
}