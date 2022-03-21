output "s3_role_arn" {
  value = aws_iam_role.beanstalk_ec2.arn
}