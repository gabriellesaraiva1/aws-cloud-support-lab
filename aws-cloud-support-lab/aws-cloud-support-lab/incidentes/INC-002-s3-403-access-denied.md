# INC-002 — Erro 403 ao acessar objeto no S3

| Campo | Valor |
|---|---|
| **ID** | INC-002 |
| **Serviços** | S3, IAM |
| **Severidade** | Média |
| **Status** | ✅ Resolvido |

## 1. Descrição do incidente
Um usuário IAM não consegue baixar arquivos do bucket `lab-suporte-docs`, recebendo erro 403.

## 2. Sintomas apresentados
```
$ aws s3 cp s3://lab-suporte-docs/relatorio.pdf .
download failed: An error occurred (403) when calling the HeadObject operation: Forbidden
```
- Listagem do bucket (`aws s3 ls`) funciona.
- Download de objetos falha.

## 3. Investigação técnica
Listagem funciona, mas leitura não: indica permissão parcial.

1. **Política IAM do usuário**: continha apenas `s3:ListBucket`. Faltava `s3:GetObject`.
2. **Bucket policy**: sem `Deny` explícito. ✅
3. **Block Public Access**: ativo (esperado, não relacionado). ✅
4. **Criptografia**: SSE-S3, sem necessidade de KMS. ✅

Política encontrada:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::lab-suporte-docs"
  }]
}
```

## 4. Causa raiz
A política IAM do usuário não concedia `s3:GetObject` sobre os objetos (`arn:aws:s3:::lab-suporte-docs/*`).

## 5. Solução aplicada
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::lab-suporte-docs"
    },
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::lab-suporte-docs/*"
    }
  ]
}
```

## 6. Evidências da resolução
- `evidencias/INC-002/erro-403.png`
- `evidencias/INC-002/policy-corrigida.png`
- `evidencias/INC-002/download-sucesso.png`

## 7. Recomendações preventivas
- Lembrar que `ListBucket` se aplica ao **bucket** e `GetObject` aos **objetos** (`/*`).
- Usar o **IAM Policy Simulator** antes de entregar acessos.
- Aplicar o princípio do menor privilégio.
