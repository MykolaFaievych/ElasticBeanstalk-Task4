output "eb_sg_id" {
  value = aws_security_group.eb.id
}
output "rds_sg_id" {
  value = aws_security_group.rds.id
}