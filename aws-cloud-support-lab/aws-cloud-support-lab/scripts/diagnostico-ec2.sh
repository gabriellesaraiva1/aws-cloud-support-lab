#!/usr/bin/env bash
# Diagnóstico rápido de uma instância EC2 via AWS CLI
# Uso: ./diagnostico-ec2.sh i-0abc1234567890def [regiao]

set -euo pipefail

INSTANCE_ID="${1:?Informe o ID da instância}"
REGION="${2:-us-east-1}"

echo "== Estado e status checks =="
aws ec2 describe-instance-status --instance-ids "$INSTANCE_ID" \
  --include-all-instances --region "$REGION" \
  --query "InstanceStatuses[].{Estado:InstanceState.Name,Sistema:SystemStatus.Status,Instancia:InstanceStatus.Status}" \
  --output table

echo "== Rede e Security Groups =="
aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region "$REGION" \
  --query "Reservations[].Instances[].{IPPublico:PublicIpAddress,IPPrivado:PrivateIpAddress,Subnet:SubnetId,VPC:VpcId,SGs:SecurityGroups[].GroupId}" \
  --output json

echo "== Console output (últimas linhas) =="
aws ec2 get-console-output --instance-id "$INSTANCE_ID" --region "$REGION" \
  --latest --output text | tail -n 30

echo "== CPU média (última hora) =="
aws cloudwatch get-metric-statistics --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value="$INSTANCE_ID" \
  --start-time "$(date -u -d '1 hour ago' +%FT%TZ)" \
  --end-time "$(date -u +%FT%TZ)" \
  --period 300 --statistics Average --region "$REGION" \
  --query "sort_by(Datapoints,&Timestamp)[].{Hora:Timestamp,CPU:Average}" \
  --output table
