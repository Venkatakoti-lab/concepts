resource "aws_instance" "roboshop" {
  ami           = var.ami_id
  instance_type = var.environment == "dev" ? "t2.micro" : "t3.micro"
  tags = {
    Name = "Functions-demo"
  }
}