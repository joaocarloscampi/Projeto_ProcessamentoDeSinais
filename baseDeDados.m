%% Inicialização
clc
clear
close all

%% Base de dados de treinamento
diretorio = "Amostras/Amostra_";
quantidade = 13;

database_train = [];

for i=1:quantidade
    n_amostra = int2str(i);
    diretorio_i = diretorio + n_amostra;
    disp(diretorio_i)
    
    load(diretorio_i)
    database_train = [database_train; matriz_resultados];
end

save('database_train', 'database_train')
%% Base de dados de Teste
diretorio = "Teste/Amostra_";
quantidade = 5;

database_test = [];

for i=1:quantidade
    n_amostra = int2str(i);
    diretorio_i = diretorio + n_amostra;
    disp(diretorio_i)
    
    load(diretorio_i)
    database_test = [database_test; matriz_resultados];
end

save('database_test', 'database_test')