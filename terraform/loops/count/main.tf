resource "aws_instance" "roboshop" {
  count                  = length(var.instance_names)
  ami                    = var.ami_id
  instance_type          = var.instance_types
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = {
    Name = var.instance_names[count.index]
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow-all"
  description = "allow all protocols"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-all"
  }
}