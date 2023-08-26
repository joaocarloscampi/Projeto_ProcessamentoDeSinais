%% Inicialização

clear
clc
close all

%% Leitura de dados
data = csvread("Data/S19_data.csv",1,0);
labels = csvread("Data/S19_labels.csv",3,0);

%% Variaveis - Alterar conforme a necessidade

% Titulo do arquivo de salvamento
titulo = "Amostra_5";

% Flag de plotar os gráficos
plotFigures = true;

% Frequência de amostragem
Fs = 250;

% Plot de figuras
idx_fig = 0;

% Grau do polinomio detrend
grau1 = 10;
grau2 = 10;

% Ordem do filtro média movel
ordem1 = 200;
ordem2 = 200;

% Porcentagem da piscada na janela para ser considerada
porcentagem = 0.5;

% Janela da piscada
duracao_piscada = 0.7;

% Janela de analise
passo = 200;
janela_movel = 2*passo;

%% Aquisição 
Fs = data(1,13);                                        % Frequencia de aquisicao

tempo = data(:,1);                                      % Vetor de tempo
tempo = linspace(tempo(1),tempo(end),length(tempo));    % Vetor de tempo otimizado
FP1 = data(:,2);                                        % Dados do sensor FP1
FP2 = data(:,3);                                        % Dados do sensor FP2

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP1)
title("Dados do sensor FP1")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP2)
title("Dados do sensor FP2")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%% Detrend

FP1_detrend = detrend(FP1,grau1);                               % Tirando tendencia do sinal FP1
FP2_detrend = detrend(FP2,grau2);                               % Tirando tendencia do sinal FP2

FP1_detrend = FP1_detrend/(max(FP1_detrend)-min(FP1_detrend));  % Normalizando FP1
FP2_detrend = FP2_detrend/(max(FP2_detrend)-min(FP2_detrend));  % Normalizando FP2

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP1_detrend)
title("Dados do sensor FP1 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP2_detrend)
title("Dados do sensor FP2 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

% % Teager-Kaiser energy operator - Testar melhor depois
% FP1_detrend_K = zeros(length(FP1_detrend), 1);
% 
% for i = 2:length(FP1_detrend)-1
%     FP1_detrend_K(i) = FP1_detrend(i)^2 - FP1_detrend(i-1)*FP1_detrend(i+1);
% end
% figure(99)
% hold on
% plot(tempo2,FP1_detrend_K)

%% Separar as labels

timeBlinks = [];        % Vetor de piscadas com label 1
for i=1:length(labels(:,1)) % Varredura para encontrar as piscadas
    if labels(i,2) == 1
        timeBlinks(end+1) = labels(i,1);
    end
end

%% Classificação de janelas

indice_inicio = 1;                                              % Criação da primeira janela
indice_final = janela_movel;

numero_janelas = floor(length(tempo)/passo) - 1;                % Calculo do número de janelas

matriz_resultados = zeros(numero_janelas, janela_movel*2+1);    % Criação da matriz final com os dados classificados

linha = 1;                                                      % Contador de linhas (janelas)
while (indice_final < length(tempo))                            % Enquanto o final da janela não tiver atingido o final do vetor
    tempo_inicio = indice_inicio/Fs;                            % Tempos da janela
    tempo_final = indice_final/Fs;
    
    for i=1:length(timeBlinks)                                  % Varredura nas piscadas com label 1
        start_blink = timeBlinks(i) - duracao_piscada/2;        % Tempo de início da piscada
        
        if (tempo_inicio < start_blink && tempo_final > start_blink)        % Se a piscada analisada está na janela
            if (tempo_final - start_blink)/duracao_piscada > porcentagem    % Se a janela tiver uma porcentagem maior que o limiar
                classificacao = 1;
                break
            else
                classificacao = 0;
            end
        else
            classificacao=0;
        end
        
    end
    
    % Normalizar os valores na média
    mean_piscada_1 = mean(FP1_detrend(indice_inicio:indice_final));
    resultado_FP1 = FP1_detrend(indice_inicio:indice_final) + abs(mean_piscada_1);
    
    mean_piscada_2 = mean(FP2_detrend(indice_inicio:indice_final));
    resultado_FP2 = FP2_detrend(indice_inicio:indice_final) + abs(mean_piscada_2);
    
    % Montagem da matriz de resultados: FP1 | FP2 | Classificacao
    matriz_resultados(linha, 1:janela_movel) = resultado_FP1;
    matriz_resultados(linha, janela_movel+1:janela_movel*2) = resultado_FP2;
    matriz_resultados(linha, end) = classificacao;
    
    % Mover a janela com o passo
    indice_inicio = indice_inicio + passo;
    indice_final = indice_final + passo;
    linha = linha + 1;
end

% Salvar os dados
save(titulo, 'matriz_resultados')

%% Plot das classificações

if plotFigures
    for i=1:length(matriz_resultados(:,1))
      if matriz_resultados(i,801)==1
          idx_fig = idx_fig + 1;
          figure(idx_fig)
          plot(matriz_resultados(i,1:800))
          grid on
      end
    end
end

