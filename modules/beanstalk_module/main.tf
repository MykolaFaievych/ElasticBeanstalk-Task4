data "archive_file" "function-zip" {
  type        = "zip"
  source_dir  = "${path.module}/eb"
  output_path = "${var.ver}.zip"
}

resource "aws_s3_object" "object" {
  bucket = "${var.env}-s3bucket"
  key    = "${var.ver}.zip"
  source = "<your_path_to_file>.zip"
}

resource "aws_elastic_beanstalk_application" "beanstalk" {
  name        = "${var.env}-test"
  description = "${var.env}-desc"
}

resource "aws_elastic_beanstalk_application_version" "eb" {
  name        = var.ver
  application = "${var.env}-test"
  description = "${var.env}-desc"
  bucket      = "${var.env}-s3bucket"
  key         = "${var.ver}.zip"
  depends_on = [
    aws_s3_object.object
  ]

}

resource "aws_elastic_beanstalk_environment" "app-env" {
  name                = "${var.env}-test"
  application         = aws_elastic_beanstalk_application.beanstalk.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.11 running PHP 8.0"
  version_label       = aws_elastic_beanstalk_application_version.eb.name

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.vpc_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.iam_role
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.key_name
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "True"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.public_subnet_ids)
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = var.instance_type
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = 1
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.eb_sg_id
  }



}
