variable "env" {}
variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "eb_sg_id" {}
variable "iam_role" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  default = "<your_key>"

}
variable "ver" {
  default = "version5.8"
}