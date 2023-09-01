# Projeto_ProcessamentoDeSinais
Projeto realizado para a disciplina de Tópicos em Processamento de Sinais em Tempo Discreto, ministrada pelo Professor Samuel do Departamento de Engenharia Elétrica (DEE), consistindo na detecção de piscadas a partir de dados de EEG dos sensores FP1 e FP2.

Grupo:
- Giovanna Amorim Nascimento - 784267
- João Carlos Tonon Campi - 769723
- Vinicius Rocha Caetano - 800356


# Conteúdo do repositório
Este repositório está organizado de duas formas. As pastas contém os dados utilizados para o projeto, enquanto os arquivos na raiz são os códigos-fonte executados.

## Dados
- **Data:** Pasta onde se encontram os dados em csv obtidos diretamente da base de dados, alterando os espaçadores de ; para , 
- **Amostras:** Amostras processadas pelo arquivo preProcessamento.m utilizadas para o treinamento das redes neurais
- **Teste:** Amostras processadas pelo arquivo preProcessamento.m utilizadas para a validação das redes neurais

## Arquivos
- **analiseFourier.m:** Arquivo auxiliar para analisar o espectro de frequência de uma única piscada, para projeto dos filtros digitais
- **baseDeDados.m:** Arquivo para criar as bases de dados formatadas como a rede neural precisa, tanto de teste quanto de validação, para a rede que utiliza apenas os dados dos sensores
- **baseDeDados_Filtro.m:** Semelhante a baseDeDados, mas cria as bases com os dados dos sensores e energia, e só com energia
- **energiaSinal.m:** Função pra calcular a energia do sinal filtrado
- **filtragemBanco.m:** Implementação do banco de filtros, retornando a energia do sinal para cada filtro
- **preProcessamento.m:** Arquivo responsável por criar as amostras a partir da base de dados original, aplicando o detrend

## Rede Neural
As redes utilizadas nesse projeto foram criadas utilizando o App Neural Net Pattern Recognition do MATLAB, a partir dos dados gerados nos arquivos baseDeDados explicados acima.

## Documento
O documento em PDF presente neste repositório possui o relatório em formato de artigo do projeto proposto.
