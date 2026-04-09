# Multivariate Analysis of Battery Failure

Este repositório apresenta uma aplicação de **Análise Estatística Multivariada** para modelar o tempo de vida de baterias de prata-zinco, com base em variáveis operacionais, a qual a foi a proposta de trabalho final da disciplina _Análise Estatística Multivariada_ realizada durante minha graduação na UFRJ.

## Problema

O **objetivo** deste estudo é entender quais fatores influenciam o número de ciclos até a falha de uma bateria, e construir um modelo estatístico capaz de explicar esse comportamento.

O conjunto de dados contém:

- 5 variáveis preditoras:
  - Taxa de carga (amps)
  - Taxa de descarga (amps)
  - Profundidade de descarga (%)
  - Temperatura (°C)
  - Voltagem de fim de carga (V)
- 1 variável resposta:
  - Número de ciclos até falha

📄 Fonte do problema está no arquivo .pdf, o qual foi retirado do livro _Applied Multivariate Statistical Analysis - Johnson & Wichern_

---

## Etapas da Análise

### 1. Análise Exploratória
- Visualização de distribuições (boxplots)
- Análise de dispersão
- Matriz de correlação

Insight importante:
- A variável **temperatura (z4)** apresentou maior correlação com o tempo de vida da bateria 

---

### 2. Modelagem por Regressão Linear

Foram testados diferentes modelos:

#### Modelo 1 — Completo
- Todas as variáveis incluídas
- R² ≈ 66%

#### Modelo 2 — Seleção de Variáveis (Stepwise)
- Variáveis selecionadas: z2 (descarga) e z4 (temperatura)
- R² ≈ 60%

#### Modelo 3 — Sem intercepto (melhor modelo)
- Variáveis: z2 e z4
- R² ≈ **90.62%**
- Melhor ajuste e melhor comportamento dos resíduos

**Conclusão**:
- Um modelo simples com poucas variáveis pode explicar bem o fenômeno

---

### 3. Análise de Componentes Principais (PCA)

- Redução de dimensionalidade
- Primeiras 4 componentes explicam ≈ 86.77% da variância 

#### Modelo com PCA:
- R² ≈ 66%

Insight:
- PCA não melhorou o desempenho do modelo neste caso

---

## Resultados Principais

- Temperatura é a variável mais relevante
- Modelos mais simples tiveram melhor desempenho
- PCA não trouxe ganho significativo (possível efeito da natureza discreta dos dados)

---

## Tecnologias Utilizadas

- R
- Regressão Linear
- PCA (Principal Component Analysis)
- Análise de resíduos
- Testes de normalidade (Shapiro-Wilk)
