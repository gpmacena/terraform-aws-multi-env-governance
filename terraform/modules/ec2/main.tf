resource "aws_key_pair" "this" {
  key_name   = "${var.key_name}-${terraform.workspace}"
  public_key = var.public_key  
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  # Mesmo sem a chave física, mantenha a referência se ela existir no código
  key_name               = aws_key_pair.this.key_name 

  # Script de automação total para Ubuntu
  user_data = <<-EOF
              #!/bin/bash
              # Atualiza repositórios e instala dependências básicas
              apt-get update -y
              apt-get install -y wget

              # Download e instalação do Node Exporter
              cd /tmp
              wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
              tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz
              mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/

              # Criação do serviço Systemd apontando para o usuário padrão do Ubuntu
              cat <<SERVICE > /etc/systemd/system/node_exporter.service
              [Unit]
              Description=Node Exporter
              After=network.target

              [Service]
              User=ubuntu
              ExecStart=/usr/local/bin/node_exporter
              Restart=always

              [Install]
              WantedBy=multi-user.target
              SERVICE

              # Inicialização do serviço
              systemctl daemon-reload
              systemctl enable node_exporter
              systemctl start node_exporter
              EOF

  tags = {
    Name      = "server-${terraform.workspace}"
    Env       = var.environment
    monitorar = "true" 
  }
}