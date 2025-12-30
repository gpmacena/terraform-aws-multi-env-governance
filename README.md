# 🧪 Cloud Native DevOps Lab — Enterprise Governance & Multi-Env

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Prometheus](https://img.shields.io/badge/prometheus-%23E6522C.svg?style=for-the-badge&logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

Laboratório Cloud Native focado em **Governança Enterprise**, isolamento de ambientes e observabilidade avançada na AWS. Este projeto utiliza **Terraform Workspaces** e **Service Discovery** para gerenciar infraestruturas dinâmicas com foco em escalabilidade e baixo custo.

---

## 🎯 Objetivo do Projeto

Criar um ecossistema de infraestrutura profissional para estudo e portfólio, abordando:

- **Infraestrutura como Código:** Provisionamento modular com Terraform e isolamento total via Workspaces (Dev/Prod).
- **Governança & FinOps:** Pipeline de CI/CD com fluxos de aprovação manual para o ambiente de produção e destruição de recursos.
- **Observabilidade Dinâmica:** Stack de monitoramento (Prometheus & Grafana) com **EC2 Service Discovery**, capturando instâncias automaticamente via tags.
- **Multi-Runtime:** Estrutura agnóstica preparada para hospedar aplicações em Java, Node.js e .NET através de User Data automatizado.

---

## 🏗️ Arquitetura de Infraestrutura (IaC)

A infraestrutura é gerenciada de forma modular, permitindo a reutilização do código para múltiplos ambientes:

- **State Management:** Backend remoto em S3 (`sa-east-1`) com suporte a estados isolados por Workspace.
- **Network Strategy:** VPC customizada com isolamento de Security Groups para SSH (22) e monitoramento (9100).
- **Compute:** Instâncias EC2 provisionadas com nomes dinâmicos (ex: `server-dev`, `server-prod`) baseados no contexto do Terraform.

---

## 🚀 Esteira de CI/CD (GitHub Actions)

O projeto implementa uma pipeline robusta com foco em **segurança e automação**:

- **Fluxo Multi-Branch:** Deploys automáticos em **Dev** (via branch `develop`) e deploys controlados em **Prod** (via branch `main`).
- **Aprovação Manual:** O ambiente de produção exige validação humana (Review Deployment) antes de qualquer alteração na infraestrutura.
- **Workflow Dispatch:** Possibilidade de executar manualmente ações de `apply` ou `destroy` escolhendo o ambiente via interface do GitHub.

---

## 📌 Roadmap do Projeto

### Fase 1 — Governança e Base ✅
- [x] Terraform modularizado e Backend Remoto (S3).
- [x] Implementação de Workspaces (Isolamento Dev/Prod).

### Fase 2 — Pipeline e CI/CD ✅
- [x] Configuração de ambientes no GitHub (Environments).
- [x] Pipeline com lógica de decisão baseada em branch e inputs manuais.

### Fase 3 — Observabilidade Automática ✅
- [x] Configuração do Node Exporter via User Data.
- [x] Implementação de **AWS Service Discovery** no Prometheus.
- [x] Dashboard dinâmico no Grafana com filtro por instâncias.

---

## 🛠️ Como Executar

### Operação via GitHub Actions
1. Configure as `Secrets` (`AWS_ACCESS_KEY_ID` e `AWS_SECRET_ACCESS_KEY`) no repositório.
2. Para **DEV**: Faça o `push` para a branch `develop`.
3. Para **PROD**: Faça o `merge` para a branch `main` e aprove o deployment manual.
4. Para **Encerrar**: Use o "Run workflow", selecione a ação `destroy` e o ambiente desejado.

### Execução Local (Debug)
```bash
# Entrar na pasta do projeto
cd terraform

# Inicializar e selecionar o ambiente
terraform init
terraform workspace select dev || terraform workspace new dev

# Aplicar mudanças
terraform apply -var="environment=dev" -var-file="environments/dev.tfvars" -auto-approve