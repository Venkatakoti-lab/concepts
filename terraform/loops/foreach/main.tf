resource "aws_instance" "roboshop" {
  for_each               = var.instance_names
  ami                    = var.ami_id
  instance_type          = each.value
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = {
    Name = each.key
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow-ssh"
  description = "this sg for ec2"
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-ssh"
  }
}