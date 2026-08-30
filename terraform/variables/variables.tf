variable "ami_id" {
  type    = string
  default = "ami-0220d79f3f480ecf5"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "instance_name" {
  default = "Variable-demo"
}

variable "sg_name" {
  default = "allow-all"
}
variable "sg_description" {
  default = "allow-all"
}
variable "ingress_from_port" {
  default = 0
}
variable "ingress_to_port" {
  default = 0
}
variable "ingress_protocol" {
  default = "-1"
}
variable "ingress_cidr" {
  default = ["0.0.0.0/0"]
}

variable "egress_from_port" {
  default = 0
}
variable "egress_to_port" {
  default = 0
}
variable "egress_protocol" {
  default = "-1"
}
variable "egress_cidr" {
  default = ["0.0.0.0/0"]
}
variable "sg_tags" {
  default = {
    Name = "allow-all"
  }
}