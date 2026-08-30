resource "aws_instance" "icici"{
    ami= local.ami
    instance_type = var.environment == "dev" ? "t3.micro" : "t3.small"
    vpc_security_group_ids = [ aws_security_group.allow_all.id ]
    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = self.public_ip
    }
    provisioner "remote-exec" {
        inline = [
            "sudo dnf install nginx -y",
            "echo 'This server is from::  ${var.environment}' | sudo tee /usr/share/nginx/html/index.html",
            "sudo systemctl enable nginx",
            "sudo systemctl restart nginx"
        ]
    }
    provisioner "remote-exec"{
        when = destroy
        inline = [
            "sudo systemctl stop nginx"
        ]
    }
    tags= merge(
        var.common_tags,
        {
            Name= "${var.project_name}-${var.environment}"
        }
    )
}
resource "aws_security_group" "allow_all"{
    name = "${var.project_name}-${var.environment}-allow-all"
    description = "this sg is allowing all protocols"
    dynamic "ingress" {
      for_each = var.ingress
      content{
        from_port = ingress.value["from_port"]
        to_port = ingress.value["to_port"]
        protocol = ingress.value["protocol"]
        cidr_blocks = ingress.value["cidr_blocks"]
      }
    }
    egress {
        from_port= 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    tags = merge(
        var.common_tags,
        {
            Name= "${var.project_name}-${var.environment}"
        }
    )
}