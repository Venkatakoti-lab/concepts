variable "ami_id" {
  type    = string
  default = "ami-0220d79f3f480ecf5"
}
variable "instance_types" {
  default = "t3.micro"
}
variable "instance_names" {
  default = ["mongodb", "redis", "mysql", "rabbitmq"]
}