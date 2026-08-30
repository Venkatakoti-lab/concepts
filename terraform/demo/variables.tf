variable "environment" {
  default = ""
}
variable "common_tags" {
  default = {
    project= "roboshop"
    terraform= true
  }
}
variable "project_name" {
  default = "roboshop"
}
variable "ingress"{
    default = [
        {
            from_port= "22"
            to_port= "22"
            protocol= "tcp"
            cidr_blocks= [ "0.0.0.0/0" ]
        },
        {
            from_port= "80"
            to_port= "80"
            protocol= "tcp"
            cidr_blocks= [ "0.0.0.0/0" ]
        },
        {
            from_port= "8080"
            to_port= "8080"
            protocol= "tcp"
            cidr_blocks= [ "0.0.0.0/0" ]
        }
    ]
}