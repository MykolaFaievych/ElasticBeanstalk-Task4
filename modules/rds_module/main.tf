resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$"
}
resource "aws_ssm_parameter" "rds_password" {
  name        = "rds-creds"
  description = "Master Password for RDS"
  type        = "SecureString"
  value       = random_string.rds_password.result
  depends_on = [
    random_string.rds_password
  ]
}
data "aws_ssm_parameter" "rds_password" {
  name       = "rds-creds"
  depends_on = [aws_ssm_parameter.rds_password]
}

resource "aws_db_instance" "rds-instance" {
  db_name                 = "task"
  identifier              = var.env
  allocated_storage       = 5
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0.23"
  instance_class          = "db.t3.micro"
  backup_retention_period = "3"
  publicly_accessible     = "false"
  username                = var.rds_username
  password                = data.aws_ssm_parameter.rds_password.value
  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.rds-subnet-group.name
  parameter_group_name    = aws_db_parameter_group.rds-parameters.name
  multi_az                = "true"
  skip_final_snapshot     = "true"
  depends_on = [
    aws_ssm_parameter.rds_password
  ]
}

resource "aws_db_parameter_group" "rds-parameters" {
  name        = "rds-parameters"
  family      = "mysql8.0"
  description = "MySQL parameter group"
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "rds-subnet-group"
  description = "Allowed subnets for RDS cluster instances"
  subnet_ids  = var.private_subnet_ids
}