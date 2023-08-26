%% Importação da base de dadados
clear 
close all
clc

load('database.mat');

%% Parametros
data_FP1 = database(11,1:400);
data_FP2 = database(11,401:800);
Fs = 250;
N = length(data_FP1);

%% FFT do sinal original
Y_FP1 = fft(data_FP1)/N;
Y_FP2 = fft(data_FP2)/N;
m = 0:N-1;
f = Fs/N * m;

magY_FP1 = 2*abs(Y_FP1);
magY_FP2 = 2*abs(Y_FP2);

figure(1)
hold on

subplot(2,1,1)
stem(f,magY_FP1,'b.')
xlim([0,125])
title("Dado original FP1")
grid on

subplot(2,1,2)
stem(f,magY_FP2,'b.')
xlim([0,125])
title("Dado original FP2")
grid on

%% Filtragem digital passa-baixa utilizando butter
order = 4; % Empirico

% Filtro 1 - Passa baixa 2Hz
fc_range = [2]; % Frequencia de corte
[fkernB,fkernA] = butter(order,fc_range/(Fs/2)); % Criação do filtro

fimp_FP1 = filter(fkernB,fkernA,data_FP1); % Filtragem de FP1

fimp_X_FP1 = fft(fimp_FP1)/N;       % FFT do sinal filtrado FP1
mag_fimp_X_FP1 = abs(fimp_X_FP1)*2;
rms_mag_FP1 = rms(mag_fimp_X_FP1);

fimp_FP2 = filter(fkernB,fkernA,data_FP2); % Filtragem de FP2

fimp_X_FP2 = fft(fimp_FP2)/N;       % FFT do sinal filtrado FP2
mag_fimp_X_FP2 = abs(fimp_X_FP2)*2;
rms_mag_FP2 = rms(mag_fimp_X_FP2);

figure(2)
subplot(2,1,1)
stem(f, mag_fimp_X_FP1, 'b.')
title("Dado filtrado FP1")
grid on

subplot(2,1,2)
stem(f, mag_fimp_X_FP1, 'b.')
title("Dado filtrado FP2")
grid on

%% Filtragem digital passa-faixa butter utilizando for

rms_FP1 = zeros(1,5);
rms_FP2 = zeros(1,5);
rms_FP1(1) = rms_mag_FP1;
rms_FP2(1) = rms_mag_FP2;

indices = [3, 5, 7, 9];

for i=indices
    fc_range = [i-1, i+1]; % Frequencia de corte
    [fkernB,fkernA] = butter(order,fc_range/(Fs/2)); % Criação do filtro
    
    fimp_FP1 = filter(fkernB,fkernA,data_FP1); % Filtragem de FP1

    fimp_X_FP1 = fft(fimp_FP1)/N;       % FFT do sinal filtrado FP1
    mag_fimp_X_FP1 = abs(fimp_X_FP1)*2;
    rms_mag_FP1 = rms(mag_fimp_X_FP1);

    fimp_FP2 = filter(fkernB,fkernA,data_FP2); % Filtragem de FP2

    fimp_X_FP2 = fft(fimp_FP2)/N;       % FFT do sinal filtrado FP2
    mag_fimp_X_FP2 = abs(fimp_X_FP2)*2;
    rms_mag_FP2 = rms(mag_fimp_X_FP2);
    
    rms_FP1((i+1)/2) = rms_mag_FP1;
    rms_FP2((i+1)/2) = rms_mag_FP2;
end
