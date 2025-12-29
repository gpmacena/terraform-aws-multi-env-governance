resource "aws_key_pair" "this" {
  key_name   = "${var.key_name}-${terraform.workspace}"
  public_key = var.public_key  
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.this.key_name

  tags = {
    Name = "server-${terraform.workspace}"
    Env  = terraform.workspace
  }
}