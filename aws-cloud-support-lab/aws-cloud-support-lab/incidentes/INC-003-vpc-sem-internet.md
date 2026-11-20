# INC-003 — Instância em subnet privada sem acesso à internet

| Campo | Valor |
|---|---|
| **ID** | INC-003 |
| **Serviços** | VPC, EC2 |
| **Severidade** | Alta |
| **Status** | ✅ Resolvido |

## 1. Descrição do incidente
Uma instância em subnet privada não consegue instalar pacotes nem atualizar o sistema.

## 2. Sintomas apresentados
```
$ sudo yum update -y
Could not retrieve mirrorlist ... Connection timed out
$ ping -c 3 8.8.8.8
100% packet loss
```

## 3. Investigação técnica
1. **Route table da subnet**: apenas rota local (`10.0.0.0/16`), sem rota padrão.
2. **Security Group (saída)**: permite todo o tráfego. ✅
3. **NACL**: permite entrada e saída. ✅
4. Confirmado que a subnet é privada (sem rota para IGW).

## 4. Causa raiz
Ausência de rota `0.0.0.0/0` apontando para um **NAT Gateway** na route table da subnet privada.

## 5. Solução aplicada
1. Criação de um NAT Gateway em uma subnet **pública**, com Elastic IP.
2. Adição da rota na route table privada:

```bash
aws ec2 create-route \
  --route-table-id rtb-0abc1234567890def \
  --destination-cidr-block 0.0.0.0/0 \
  --nat-gateway-id nat-0abc1234567890def
```

## 6. Evidências da resolução
- `evidencias/INC-003/route-table-antes.png`
- `evidencias/INC-003/route-table-depois.png`
- `evidencias/INC-003/yum-update-sucesso.png`

## 7. Recomendações preventivas
- Usar **VPC Endpoints** (ex.: S3) para reduzir custo de NAT.
- Lembrar que o NAT Gateway tem custo por hora: remover ao fim do laboratório.
- Documentar o desenho da rede (diagrama) para toda VPC criada.
