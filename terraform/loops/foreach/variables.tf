variable "ami_id" {
  type    = string
  default = "ami-0220d79f3f480ecf5"
}

variable "instance_names" {
  default = {
    mongodb  = "t3.medum"
    redis    = "t3.micro"
    mysql    = "t3.medium"
    rabbitmq = "t3.micro"
  }
}