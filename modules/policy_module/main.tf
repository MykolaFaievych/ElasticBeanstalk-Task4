resource "aws_iam_role" "beanstalk_ec2" {
  name               = "${var.env}-beanstalk-ec2"
  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
resource "aws_iam_policy" "s3_bucket" {
  name        = "${var.env}-s3"
  description = "IAM policy for S3 bucket from EC2"

  policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Effect":"Allow",
            "Action":[
                "s3:PutObject",
                "s3:ListBucket",
                "s3:PutObjectAcl",
                "s3:GetObject",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": [
              "arn:aws:s3:::${var.env}-s3bucket",
              "arn:aws:s3:::${var.env}-s3bucket/*"
            ]
        }
    ]
    }
  EOF
}
resource "aws_iam_policy" "ec2" {
  name        = "${var.env}-ec2-eb"
  description = "IAM policy for EC2 from eb"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [{
      "Effect": "Allow",
      "Action": [
         "rds:*",
         "ec2:DescribeInstances",
         "ec2:DescribeTags", 
         "autoscaling:DescribeAutoScalingInstances",
         "autoscaling:DescribeAutoScalingGroups",
         "cloudwatch:PutMetricData", 
         "cloudwatch:GetMetricStatistics", 
         "cloudwatch:ListMetrics"
      ],
      "Resource": "*"
   }
   ]
}
  EOF
}
resource "aws_iam_role_policy_attachment" "attach-ec2" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = aws_iam_policy.ec2.arn
}
resource "aws_iam_role_policy_attachment" "attach-s3" {
  role       = aws_iam_role.beanstalk_ec2.name
  policy_arn = aws_iam_policy.s3_bucket.arn
}