# ☁️ Laboratório de Suporte AWS Cloud

Laboratório prático de **Cloud Support** com AWS, focado em troubleshooting, monitoramento e resolução de incidentes.

![AWS](https://img.shields.io/badge/AWS-Cloud%20Support-FF9900?logo=amazonaws&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Troubleshooting-FCC624?logo=linux&logoColor=black)
![Status](https://img.shields.io/badge/status-em%20andamento-blue)

---

## 📌 Sobre o projeto

Este laboratório simula situações reais de suporte em nuvem: investigar incidentes, identificar a causa raiz de falhas e documentar soluções técnicas de forma clara e reproduzível, como em um chamado de suporte de verdade.

## 🛠️ Serviços AWS utilizados

| Serviço | Uso no laboratório |
|---|---|
| **Amazon EC2** | Gerenciamento e diagnóstico de servidores virtuais |
| **Amazon S3** | Armazenamento e permissões de arquivos |
| **Amazon VPC** | Configuração e diagnóstico de redes |
| **AWS IAM** | Gerenciamento de usuários, funções e permissões |
| **Amazon CloudWatch** | Monitoramento de recursos, métricas e logs |

## 🧪 Atividades práticas

- Diagnóstico de instâncias EC2
- Investigação de erros 403 no S3
- Solução de problemas de conectividade
- Análise de permissões e políticas IAM
- Monitoramento de servidores
- Investigação e documentação de incidentes

## 📋 Metodologia

Cada chamado é documentado com:

1. Descrição do incidente
2. Sintomas apresentados
3. Investigação técnica
4. Identificação da causa raiz
5. Solução aplicada
6. Evidências da resolução
7. Recomendações preventivas

Veja o [template de incidente](templates/template-incidente.md) e a [metodologia detalhada](docs/metodologia.md).

## 🎫 Índice de chamados

| ID | Título | Serviço | Severidade | Status |
|---|---|---|---|---|
| [INC-001](incidentes/INC-001-ec2-ssh-timeout.md) | Timeout ao acessar EC2 via SSH | EC2 / VPC | Alta | ✅ Resolvido |
| [INC-002](incidentes/INC-002-s3-403-access-denied.md) | Erro 403 ao acessar objeto no S3 | S3 / IAM | Média | ✅ Resolvido |
| [INC-003](incidentes/INC-003-vpc-sem-internet.md) | Instância em subnet privada sem acesso à internet | VPC | Alta | ✅ Resolvido |
| [INC-004](incidentes/INC-004-iam-access-denied.md) | AccessDenied em usuário IAM | IAM | Média | ✅ Resolvido |
| [INC-005](incidentes/INC-005-cloudwatch-cpu-alarme.md) | Alarme de CPU alta no CloudWatch | EC2 / CloudWatch | Alta | ✅ Resolvido |

## 📂 Estrutura do repositório

```
aws-cloud-support-lab/
├── README.md
├── docs/
│   ├── metodologia.md
│   └── checklist-troubleshooting.md
├── templates/
│   └── template-incidente.md
├── incidentes/
│   └── INC-00X-*.md
├── scripts/
│   └── diagnostico-ec2.sh
└── evidencias/
    └── INC-00X/   (prints e logs)
```

## 🧰 Habilidades desenvolvidas

- Suporte AWS Cloud
- Resolução de problemas (troubleshooting)
- Linux
- Redes de computadores
- Monitoramento
- Segurança e controle de acesso
- Análise de logs
- Documentação técnica

## 🎯 Objetivo profissional

Desenvolver conhecimentos práticos para atuar como **Analista de Suporte em Nuvem**, com foco em diagnóstico, suporte técnico e resolução de incidentes em ambientes de nuvem.

## ⚠️ Aviso

Este laboratório foi feito em conta pessoal, com recursos do Free Tier. Nenhuma credencial, chave ou ID de conta real é publicada neste repositório. Valores sensíveis estão substituídos por exemplos (`123456789012`, `i-0abc...`).

## 📫 Contato

- LinkedIn: _adicione seu link_
- GitHub: _adicione seu perfil_

---
📄 Licença MIT
