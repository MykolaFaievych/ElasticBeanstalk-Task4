module "eb" {
  source            = "./modules/beanstalk_module"
  env               = "task4"
  iam_role          = "aws-elasticbeanstalk-ec2-role"
  vpc_id            = data.aws_vpc.target_vpc.id
  eb_sg_id          = data.aws_security_group.eb.id
  public_subnet_ids = data.aws_subnet_ids.public.ids
}
