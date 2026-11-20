# Metodologia de Atendimento

Fluxo usado em todos os chamados do laboratório.

## 1. Descrição do incidente
O que o "cliente" relatou, com data/hora, serviço e impacto.

## 2. Sintomas apresentados
Mensagens de erro, comportamento observado, o que funciona e o que não funciona.

## 3. Investigação técnica
Passo a passo do raciocínio: hipóteses levantadas, comandos executados, logs e métricas consultados. Descartar hipóteses também faz parte da documentação.

## 4. Causa raiz
Uma frase objetiva explicando **por que** o problema ocorreu (não apenas o sintoma).

## 5. Solução aplicada
Ações executadas, com comandos ou configurações exatas.

## 6. Evidências da resolução
Prints, saídas de comandos e métricas mostrando que o problema foi corrigido.

## 7. Recomendações preventivas
Como evitar recorrência: monitoramento, automação, boas práticas, least privilege.

## Níveis de severidade

| Nível | Critério |
|---|---|
| Crítica | Produção fora do ar, impacto total |
| Alta | Funcionalidade principal indisponível |
| Média | Impacto parcial ou com contorno disponível |
| Baixa | Dúvida, melhoria ou impacto mínimo |
