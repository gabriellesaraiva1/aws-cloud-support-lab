# INC-004 — AccessDenied em usuário IAM

| Campo | Valor |
|---|---|
| **ID** | INC-004 |
| **Serviços** | IAM, EC2, CloudTrail |
| **Severidade** | Média |
| **Status** | ✅ Resolvido |

## 1. Descrição do incidente
Um analista júnior não consegue reiniciar instâncias EC2, mas consegue visualizá-las.

## 2. Sintomas apresentados
```
An error occurred (UnauthorizedOperation) when calling the RebootInstances operation:
You are not authorized to perform: ec2:RebootInstances on resource: arn:aws:ec2:...
```

## 3. Investigação técnica
1. Usuário pertence ao grupo `Suporte-ReadOnly` (policy `AmazonEC2ReadOnlyAccess`).
2. Verificação no **IAM Policy Simulator**: `ec2:RebootInstances` → *implicitly denied*.
3. Consulta no **CloudTrail** confirmou o evento negado:

```bash
aws cloudtrail lookup-events \
  --lookup-attributes AttributeKey=EventName,AttributeValue=RebootInstances
```
4. Sem SCP, permissions boundary ou `Deny` explícito.

## 4. Causa raiz
O usuário só possuía permissões de leitura; faltava permissão explícita para `ec2:RebootInstances`.

## 5. Solução aplicada
Policy customizada com menor privilégio, restrita por tag:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["ec2:RebootInstances"],
    "Resource": "arn:aws:ec2:*:*:instance/*",
    "Condition": {
      "StringEquals": { "aws:ResourceTag/Ambiente": "Lab" }
    }
  }]
}
```

## 6. Evidências da resolução
- `evidencias/INC-004/policy-simulator.png`
- `evidencias/INC-004/cloudtrail-evento.png`
- `evidencias/INC-004/reboot-sucesso.png`

## 7. Recomendações preventivas
- Usar grupos e roles em vez de permissões diretas ao usuário.
- Restringir ações sensíveis por tag e recurso.
- Habilitar MFA e revisar permissões com **IAM Access Analyzer**.
