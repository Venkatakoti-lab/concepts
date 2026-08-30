resource "aws_instance" "roboshop" {
  #   count         = length(var.instance_names)
  ami           = local.ami
  instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.allow_all.id]
  provisioner "local-exec" {
    command = "echo server ip is ${self.private_ip} >inventory "
  }
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }
  connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "sudo dnf install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
  provisioner "remote-exec" {
    when= destroy
    inline = [ 
        "sudo systemctl stop nginx"
    ]
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}
resource "aws_security_group" "allow_all" {
  name = "allow-all"
  dynamic "ingress"{
    for_each = var.ingress
    content {
      from_port = ingress.value["from_port"]
      to_port = ingress.value["to_port"]
      protocol = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.common_tags,
    {
        Name= "${var.project_name}-${var.environment}"
    }
  )
}