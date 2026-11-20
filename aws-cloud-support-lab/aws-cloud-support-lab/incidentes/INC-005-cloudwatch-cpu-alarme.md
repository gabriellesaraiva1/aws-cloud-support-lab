# INC-005 — Alarme de CPU alta no CloudWatch

| Campo | Valor |
|---|---|
| **ID** | INC-005 |
| **Serviços** | EC2, CloudWatch, SNS |
| **Severidade** | Alta |
| **Status** | ✅ Resolvido |

## 1. Descrição do incidente
Alarme do CloudWatch disparou por CPU acima de 80% em uma instância EC2, com lentidão relatada na aplicação.

## 2. Sintomas apresentados
- Alarme `CPU-Alta-Web01` em estado `ALARM`.
- Aplicação lenta e com timeouts intermitentes.

## 3. Investigação técnica
1. Métrica `CPUUtilization` no CloudWatch: pico sustentado a partir de determinado horário.
2. Acesso à instância e identificação do processo:

```bash
top -o %CPU
ps aux --sort=-%cpu | head -5
journalctl -u httpd --since "1 hour ago"
tail -n 100 /var/log/messages
```
3. Processo de um script de backup executando em loop, sem limite, consumindo ~95% de CPU.

## 4. Causa raiz
Um script de backup agendado no `cron` estava sendo disparado repetidamente, sem controle de execução simultânea, saturando a CPU.

## 5. Solução aplicada
1. Encerrar processos duplicados (`kill`).
2. Ajustar o cron e adicionar trava de execução única:

```bash
*/30 * * * * flock -n /tmp/backup.lock /opt/scripts/backup.sh
```
3. Criar alarme com notificação:

```bash
aws cloudwatch put-metric-alarm \
  --alarm-name CPU-Alta-Web01 \
  --metric-name CPUUtilization --namespace AWS/EC2 \
  --statistic Average --period 300 --evaluation-periods 2 \
  --threshold 80 --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=i-0abc1234567890def \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:alertas-suporte
```

## 6. Evidências da resolução
- `evidencias/INC-005/grafico-cpu-pico.png`
- `evidencias/INC-005/top-processo.png`
- `evidencias/INC-005/grafico-cpu-normalizado.png`

## 7. Recomendações preventivas
- Instalar o **CloudWatch Agent** para métricas de memória e disco.
- Usar `flock` em tarefas agendadas.
- Avaliar Auto Scaling e right-sizing da instância.
