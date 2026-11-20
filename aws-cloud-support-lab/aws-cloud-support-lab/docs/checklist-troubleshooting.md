# Checklist de Troubleshooting AWS

## EC2 não acessível
- [ ] Instância em `running`? Status checks 2/2?
- [ ] IP público / Elastic IP associado?
- [ ] Security Group libera a porta (22/80/443) para o IP de origem?
- [ ] NACL da subnet permite entrada **e** saída (stateless)?
- [ ] Route table tem rota `0.0.0.0/0` para o Internet Gateway?
- [ ] Permissões da chave `.pem` (`chmod 400`) e usuário correto (`ec2-user`, `ubuntu`)?
- [ ] Console output / System log da instância

## S3 retornando 403
- [ ] Bucket policy nega ou não permite o principal?
- [ ] Política IAM do usuário/role permite a ação (`s3:GetObject`)?
- [ ] Block Public Access ativo?
- [ ] Objeto pertence a outra conta (ownership / ACL)?
- [ ] Criptografia KMS: usuário tem `kms:Decrypt`?
- [ ] Condições na policy (IP, VPC endpoint, MFA)?

## Sem conectividade de saída
- [ ] Subnet pública ou privada?
- [ ] Rota para IGW (pública) ou NAT Gateway (privada)?
- [ ] NAT Gateway está em subnet pública com Elastic IP?
- [ ] Security Group de saída e NACL permitem tráfego?
- [ ] Resolução DNS funcionando (`enableDnsSupport`)?

## IAM AccessDenied
- [ ] Qual ação e qual recurso foram negados? (mensagem de erro)
- [ ] Policy do usuário/grupo/role anexada?
- [ ] Existe `Deny` explícito, SCP ou permissions boundary?
- [ ] Usar **IAM Policy Simulator** e **CloudTrail** para confirmar

## Monitoramento
- [ ] Métricas básicas (CPU, rede, disco) visíveis no CloudWatch?
- [ ] CloudWatch Agent instalado para memória e disco?
- [ ] Alarmes e notificações (SNS) configurados?
