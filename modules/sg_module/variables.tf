variable "allow_ports" {
  type    = list(any)
  default = ["443", "80", "22", "5044"]
}
variable "env" {}
variable "vpc_id" {}