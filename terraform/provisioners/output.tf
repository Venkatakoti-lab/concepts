output "ami_id" {
  value = data.aws_ami.rhel9.id
}
output "public_ip" {
  value = aws_instance.roboshop.public_ip
}