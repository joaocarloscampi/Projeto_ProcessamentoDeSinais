%% Inicialização

clear all
clc
close all

%% Leitura de dados
data = csvread("Data/S01_data.csv",1,0);

%% Variaveis

% Plot de figuras
idx_fig = 0;

% Grau do polinomio detrend
grau1 = 10;
grau2 = 10;

% Ordem do filtro média movel
ordem1 = 200;
ordem2 = 200;

%% Aquisição 
Fs = data(1,13);                                        % Frequencia de aquisicao

tempo = data(:,1);                                      % Vetor de tempo
tempo2 = linspace(tempo(1),tempo(end),length(tempo));   % Vetor de tempo otimizado
FP1 = data(:,2);                                        % Dados do sensor FP1
FP2 = data(:,3);                                        % Dados do sensor FP2

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP1)
title("Dados do sensor FP1")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP2)
title("Dados do sensor FP2")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%% Detrend

FP1_detrend = detrend(FP1,grau1);                               % Tirando tendencia do sinal FP1
FP2_detrend = detrend(FP2,grau2);                               % Tirando tendencia do sinal FP2

FP1_detrend = FP1_detrend/(max(FP1_detrend)-min(FP1_detrend));  % Normalizando FP1
% FAZER PARA FP2

% Teager-Kaiser energy operator - Testar melhor depois
FP1_detrend_K = zeros(length(FP1_detrend), 1);

for i = 2:length(FP1_detrend)-1
    FP1_detrend_K(i) = FP1_detrend(i)^2 - FP1_detrend(i-1)*FP1_detrend(i+1);
end

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP1_detrend)
title("Dados do sensor FP1 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

figure(99)
hold on
plot(tempo2,FP1_detrend_K)

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP2_detrend)
title("Dados do sensor FP2 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%% Average filter

% Filtro de média móvel para o sinal FP1
B1 = 1/ordem1 * ones(ordem1,1);
a1 = ones(ordem1,1);
FP1_avgf = filter(B1,a1,FP1_detrend);

% Filtro de média móvel para o sinal FP2
B2 = 1/ordem2 * ones(ordem2,1);
a2 = ones(ordem2,1);
FP2_avgf = filter(B2,a2,FP2_detrend);

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP1_avgf)
title("Dados do sensor FP1 - Detrend + Média Movel")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo2,FP2_avgf)
title("Dados do sensor FP2 - Detrend + Média Movel")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%% FFT

N = length(FP1_avgf);
FFT_FP1 = fft(FP1_avgf)/N;

f = 0:(Fs/N):Fs/2;
FFT_FP1_half = 2*FFT_FP1(1:length(f));
FFT_FP1_half(1) = FFT_FP1_half(1)/2;

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(f,abs(FFT_FP1_half))
grid on

FFT_FP2 = fft(FP2)/N;

f = 0:(Fs/N):Fs/2;
FFT_FP2_half = 2*FFT_FP2(1:length(f));
FFT_FP2_half(1) = FFT_FP2_half(1)/2;

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(f,abs(FFT_FP2_half))
grid on