resource "aws_security_group" "web_sg" {
  name        = "web-sg-${terraform.workspace}"
  description = "SG para ambiente ${terraform.workspace}"
  vpc_id      = var.vpc_id

  # Acesso SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acesso HTTP (Aplicação)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NOVA REGRA: Porta do Node Exporter para o Prometheus Local
  ingress {
    description = "Porta do Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saída liberada para baixar o Node Exporter
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "sg-${terraform.workspace}"
    Project = "Monitoring-Lab"
  }
}