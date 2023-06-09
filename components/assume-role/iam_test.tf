data "aws_iam_policy" "test_policy" {
  provider = aws.test
  name     = "AdministratorAccess"
}

data "aws_iam_policy_document" "test_assume_role" {
  provider = aws.test
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

resource "aws_iam_role" "test_assume_role" {
  provider            = aws.test
  name                = "provision_role"
  assume_role_policy  = data.aws_iam_policy_document.test_assume_role.json
  managed_policy_arns = [data.aws_iam_policy.test_policy.arn]
  tags                = {}
}