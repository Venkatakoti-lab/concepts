resource "aws_instance" "roboshop" {
  count                  = length(var.instance_names)
  ami                    = data.aws_ami.rhel9.id
  instance_type          = var.environment == "dev" ? "t3.micro" : "t3.medium"
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  tags = merge(
    var.common_tags,
    {
      Name      = "${var.project_name}-${var.instance_names[count.index]}-${var.environment}"
      component = var.instance_names[count.index]
    }
  )
}
resource "aws_security_group" "allow_all" {
  name        = "allow-all"
  description = "allow all ports for all ips"
  

  dynamic "ingress" {
    for_each = var.ingress
    content{
        from_port   = ingress.value["from_port"]
        to_port     = ingress.value["to_port"]
        protocol    = ingress.value["protocol"]
        cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}
