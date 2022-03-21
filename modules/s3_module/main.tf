resource "template_file" "credentials" {
  template = file("${path.module}/credentials.txt")
  vars = {
    host = var.host, user = var.rds_username, pass = var.rds_password
  }
}
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.env}-s3bucket"
  tags = {
    Name = "${var.env}-s3bucket"
  }
}
resource "aws_s3_object" "object" {
  bucket  = "${var.env}-s3bucket"
  key     = "credentials.txt"
  content = template_file.credentials.rendered
  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
