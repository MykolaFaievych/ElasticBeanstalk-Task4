module "sg" {
  source = "../modules/sg_module"
  env    = "task4"
  vpc_id = data.aws_vpc.target_vpc.id
}
module "rds" {
  source             = "../modules/rds_module"
  env                = "task4"
  private_subnet_ids = data.aws_subnet_ids.private.ids
  rds_sg_id          = module.sg.rds_sg_id
  rds_username       = "root"

}
module "policy" {
  source = "../modules/policy_module"
  env    = "task4"
}
module "s3" {
  source       = "../modules/s3_module"
  env          = "task4"
  host         = module.rds.rds_name
  rds_username = "root"
  rds_password = data.aws_ssm_parameter.rds_password.value
  depends_on = [
    module.rds
  ]
}
data "aws_ssm_parameter" "rds_password" {
  name       = "rds-creds"
  depends_on = [module.rds]
}