# INC-001 — Timeout ao acessar EC2 via SSH

| Campo | Valor |
|---|---|
| **ID** | INC-001 |
| **Serviços** | EC2, VPC, Security Groups |
| **Severidade** | Alta |
| **Status** | ✅ Resolvido |

## 1. Descrição do incidente
O cliente não consegue acessar via SSH uma instância EC2 Linux recém-criada. A conexão expira sem resposta.

## 2. Sintomas apresentados
```
$ ssh -i chave.pem ec2-user@203.0.113.25
ssh: connect to host 203.0.113.25 port 22: Connection timed out
```
- Instância em estado `running`, status checks 2/2 aprovados.
- Aplicação web na porta 80 também sem resposta.

## 3. Investigação técnica
Como a instância está saudável, o problema é provavelmente de rede (timeout indica pacote descartado, não recusado).

1. **Security Group**: regra de entrada da porta 22 liberada apenas para um IP antigo (`198.51.100.10/32`), diferente do IP atual do cliente.
2. **Route table**: rota `0.0.0.0/0` → Internet Gateway presente. ✅
3. **NACL**: padrão, permitindo todo o tráfego. ✅
4. **IP público**: associado corretamente. ✅

```bash
aws ec2 describe-security-groups --group-ids sg-0abc1234567890def \
  --query "SecurityGroups[].IpPermissions"
curl -s https://checkip.amazonaws.com   # IP atual do cliente
```

## 4. Causa raiz
O Security Group permitia SSH somente para um IP que não correspondia mais ao IP público atual do cliente (IP dinâmico do provedor).

## 5. Solução aplicada
Atualização da regra de entrada para o IP atual:

```bash
aws ec2 authorize-security-group-ingress \
  --group-id sg-0abc1234567890def \
  --protocol tcp --port 22 --cidr 203.0.113.99/32

aws ec2 revoke-security-group-ingress \
  --group-id sg-0abc1234567890def \
  --protocol tcp --port 22 --cidr 198.51.100.10/32
```

## 6. Evidências da resolução
- `evidencias/INC-001/sg-antes.png`
- `evidencias/INC-001/sg-depois.png`
- `evidencias/INC-001/ssh-sucesso.png`

## 7. Recomendações preventivas
- Nunca liberar `0.0.0.0/0` na porta 22.
- Preferir **AWS Systems Manager Session Manager**, sem portas abertas.
- Documentar e revisar regras de Security Group periodicamente.
