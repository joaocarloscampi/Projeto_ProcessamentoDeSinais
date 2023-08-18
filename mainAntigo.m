%% Inicialização

clear
clc
close all

%% Leitura de dados
data = csvread("Data/S18_data.csv",1,0);

labels = csvread("Data/S18_labels.csv",2,0);

%% Variaveis

% Titulo do arquivo de salvamento
titulo = "Amostra_12";

% Plot de figuras
idx_fig = 0;

% Grau do polinomio detrend
grau1 = 10;
grau2 = 10;

% Ordem do filtro média movel
ordem1 = 200;
ordem2 = 200;

% Porcentagem para detectar os picos
porcentagem_FP1 = 0.01;
porcentagem_FP2 = 0.01;

% Janela da piscada
janela_FP1 = 100;
janela_FP2 = 100;

%% Aquisição 
Fs = data(1,13);                                        % Frequencia de aquisicao

tempo = data(:,1);                                      % Vetor de tempo
tempo = linspace(tempo(1),tempo(end),length(tempo));   % Vetor de tempo otimizado
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

% Teager-Kaiser energy operator - Testar melhor depois
FP1_detrend_K = zeros(length(FP1_detrend), 1);

for i = 2:length(FP1_detrend)-1
    FP1_detrend_K(i) = FP1_detrend(i)^2 - FP1_detrend(i-1)*FP1_detrend(i+1);
end

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP1_detrend)
title("Dados do sensor FP1 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%figure(99)
%hold on
%plot(tempo2,FP1_detrend_K)

idx_fig = idx_fig + 1;
figure(idx_fig)
plot(tempo,FP2_detrend)
title("Dados do sensor FP2 - Detrend")
xlabel("Tempo [s]")
ylabel("Amplitude")
grid on

%% Encontrar os picos 

[peaks_FP1, index_FP1] = findpeaks(-FP1_detrend,'MinPeakProminence',0.4,'Annotate','extents');
[peaks_FP2, index_FP2] = findpeaks(-FP2_detrend,'MinPeakProminence',0.3,'Annotate','extents');

time_peaks_FP1 = tempo(index_FP1);
time_peaks_FP2 = tempo(index_FP2);

timeBlinks = [];
for i=1:length(labels(:,1))
    if labels(i,2) == 1
        timeBlinks(end+1) = labels(i,1);
    end
end

real_blinks_FP1 = [];
for i=1:length(time_peaks_FP1)
    for j=1:length(timeBlinks)
        if (time_peaks_FP1(i) > timeBlinks(j) * (1-porcentagem_FP1)) && (time_peaks_FP1(i) < timeBlinks(j) * (1+porcentagem_FP1))
            %disp("Achei um meliante")
            %disp(time_peaks_FP1(i))
            %disp(timeBlinks(j))
            real_blinks_FP1(end+1) = index_FP1(i);
            j = length(timeBlinks);
        end
    end
end
real_time_blinks_FP1 = tempo(real_blinks_FP1);

real_blinks_FP2 = [];
for i=1:length(time_peaks_FP2)
    for j=1:length(timeBlinks)
        if (time_peaks_FP2(i) > timeBlinks(j) * (1-porcentagem_FP2)) && (time_peaks_FP2(i) < timeBlinks(j) * (1+porcentagem_FP2))
            %disp("Achei um meliante")
            %disp(time_peaks_FP2(i))
            %disp(timeBlinks(j))
            real_blinks_FP2(end+1) = index_FP2(i);
            j = length(timeBlinks);
        end
    end
end
real_time_blinks_FP2 = tempo(real_blinks_FP2);

%% Recorte dos picos

piscadas_FP1 = zeros( length(timeBlinks), length(-janela_FP1:janela_FP1) );
piscadas_FP2 = zeros( length(timeBlinks), length(-janela_FP2:janela_FP2) );

for i=1:length(timeBlinks)
    pico = real_blinks_FP1(i);
    piscada = FP1_detrend(pico-janela_FP1:pico+janela_FP1);
    
    min_piscada = min(piscada);
    piscada = piscada + abs(min_piscada);
    
    piscadas_FP1(i,:) = piscada;
end

piscadas_FP1(19,:) = [];
piscadas_FP1(5,:) = [];

for i=1:length(timeBlinks)
    idx_fig = idx_fig + 1;
    figure(idx_fig)
    plot(piscadas_FP1(i,:))
    grid on
end

for i=1:length(timeBlinks)
    pico = real_blinks_FP2(i);
    piscada = FP2_detrend(pico-janela_FP2:pico+janela_FP2);
    
    min_piscada = min(piscada);
    piscada = piscada + abs(min_piscada);
    
    piscadas_FP2(i,:) = piscada;
end

piscadas_FP2(19,:) = [];
piscadas_FP2(5,:) = [];

% for i=1:length(timeBlinks)
%   idx_fig = idx_fig + 1;
%   figure(idx_fig)
%   plot(piscadas_FP2(i,:))
%   grid on
% end


%save(titulo, 'piscadas_FP1')
save(titulo, 'piscadas_FP1', 'piscadas_FP2')

%% Average filter

% % Filtro de média móvel para o sinal FP1
% B1 = 1/ordem1 * ones(ordem1,1);
% a1 = ones(ordem1,1);
% FP1_avgf = filter(B1,a1,FP1_detrend);
% 
% % Filtro de média móvel para o sinal FP2
% B2 = 1/ordem2 * ones(ordem2,1);
% a2 = ones(ordem2,1);
% FP2_avgf = filter(B2,a2,FP2_detrend);
% 
% idx_fig = idx_fig + 1;
% figure(idx_fig)
% plot(tempo,FP1_avgf)
% title("Dados do sensor FP1 - Detrend + Média Movel")
% xlabel("Tempo [s]")
% ylabel("Amplitude")
% grid on
% 
% idx_fig = idx_fig + 1;
% figure(idx_fig)
% plot(tempo,FP2_avgf)
% title("Dados do sensor FP2 - Detrend + Média Movel")
% xlabel("Tempo [s]")
% ylabel("Amplitude")
% grid on
