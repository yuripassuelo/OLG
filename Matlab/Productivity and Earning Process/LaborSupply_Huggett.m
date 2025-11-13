 function [HHlaborM, L] = LaborSupply_Huggett(eIdxM, AgeMass, cS, paramS)
%% Documentação:
% Função computa dotação de trabalho individual [ind, age] e agregada
% Já que a mortalidade é aleatoria, a massa de households por idade varia por idade

% INPUT:
% eIdxM: dotação de trabalho simulada para cada uma das idades

% OUTPUTS:
% (1). LSHistM: Oferta de trabalho por individuo simulado[ind, age]
% (2). L:       Trabalho agregado 


%% Main:
% Oferta individual de trabalho: Eficiência * Dotação/Choque
HHlaborM = zeros(cS.nSim, cS.aD);
for a = 1 : cS.aD
   HHlaborM(:, a) = paramS.ageEffV(a) .* paramS.leGridV(eIdxM(:,a));
end


% Trabalho Agregado
% Dada massa de HolseHolds com idade t, mu(t), a oferta agregada de
% trabalho será:
% L = sum_(a=1 to aD) mu(a) x mean( HHlaborM(:,a) )
L = mean(HHlaborM,1)* AgeMass';


end