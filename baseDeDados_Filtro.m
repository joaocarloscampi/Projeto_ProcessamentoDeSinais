%% Inicialização
clc
clear
close all

%% Base de dados de treinamento
% Carrega a base de dados original
load("database_train");
Fs = 250;

% Separação entre entrada e saída
database_input = database_train(:,1:800);
database_output = database_train(:,801);

% Dados auxiliares
tamanho = size(database_train);
linhas = tamanho(1);
rms_database = zeros(linhas, 10);

% Filtragem de todos os sinais, adicionando RMS no vetor criado
for i=1:linhas
    dados = database_input(i, :);
    [rms1, rms2] = filtragemBanco(dados, Fs);
    rms_database(i, 1:5) = rms1;
    rms_database(i, 6:10) = rms2;
end

% Aumento da base de dados original
database_input = [database_input, rms_database];
database_with_filter_train  = [database_input, database_output];

% Salvamento dos novos dados
save('database_with_filter_train', 'database_with_filter_train')

%% Base de dados de teste
% Carrega a base de dados original
load("database_test");
Fs = 250;

% Separação entre entrada e saída
database_input = database_test(:,1:800);
database_output = database_test(:,801);

% Dados auxiliares
tamanho = size(database_test);
linhas = tamanho(1);
rms_database = zeros(linhas, 10);

% Filtragem de todos os sinais, adicionando RMS no vetor criado
for i=1:linhas
    dados = database_input(i, :);
    [rms1, rms2] = filtragemBanco(dados, Fs);
    rms_database(i, 1:5) = rms1;
    rms_database(i, 6:10) = rms2;
end

% Aumento da base de dados original
database_input = [database_input, rms_database];
database_with_filter_test  = [database_input, database_output];

% Salvamento dos novos dados
save('database_with_filter_test', 'database_with_filter_test')