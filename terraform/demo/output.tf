output "ami_info" {
  value = data.aws_ami.rhel9.id
}
output "pulic_ip" {
  value = aws_instance.roboshop.public_ip
}