output "dev_role_arn" {
  value = aws_iam_role.dev_assume_role.arn
}

output "test_role_arn" {
  value = aws_iam_role.test_assume_role.arn
}
