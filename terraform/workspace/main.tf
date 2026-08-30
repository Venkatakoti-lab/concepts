resource "aws_instance" "roboshop" {
  count                  = length(var.instances)
  ami                    = local.ami
  instance_type          = lookup(var.instance_type, terraform.workspace)
  vpc_security_group_ids = [ aws_security_group.allow_all.id ]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${var.instances[count.index]}-${terraform.workspace}"
    }
  )
}
resource "aws_security_group" "allow_all" {
  name        = "${var.project}-${terraform.workspace}"
  description = "allowing all protocols fo all ips"
  dynamic "ingress" {
    for_each = var.ingress
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project}-${terraform.workspace}"
    }
  )
}
