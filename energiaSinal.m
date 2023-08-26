function [aux] = energiaSinal(sinal)
%ENERGIASINAL Summary of this function goes here
%   Detailed explanation goes here
aux = sum(sinal.^2)/length(sinal);
end

