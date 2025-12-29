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

  user_data = <<-EOF
              #!/bin/bash
              cd /tmp
              wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
              tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
              sudo mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
              sudo tee /etc/systemd/system/node_exporter.service <<SERVICE

              [Unit]
              Description=Node Exporter
              After=network.target

              [Service]
              User=ec2-user
              ExecStart=/usr/local/bin/node_exporter
              Restart=always

              [Install]
              WantedBy=multi-user.target
              SERVICE

              # Inicialização do serviço
              sudo systemctl daemon-reload
              sudo systemctl enable --now node_exporter
              EOF


  tags = {
    Name      = "server-${terraform.workspace}"
    Env       = terraform.workspace
    monitorar = "true" 
  }
}