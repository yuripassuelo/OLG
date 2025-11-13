function [y, trProbM] = tauchen(N, pRho, pSigma, pMu, n_std)
%% Documentation
% Discretização de Processo Autoregressivo Usando Tauchen (1986) 
% Dado processo AR(1):
%           y_t = pMu + pRho y_{t-1} + epsion_t,
%            Aonde epsilon_t ~ N (0, pSigma^2)

% INPUTS:
% (1). N:       Número de pontos no processo markoviano
% (2). pRho :   Parâmetro de persistência do processo AR(1)
% (3). pSigma : Desvio padrão do componente de erro do processo AR(1)
% (4). pMu :    optional(default=0.0)
%               Média do processo AR(1)
% (5). n_std :  Opicional (default=3)
%               # de desvios padrões usados na discretização

% OUTPUTS:
% (1). y :       array(dtype=float, ndim=1)
%                1d-Array da discretização do processo AR(1)
% (2). trProbM : array(dtype=float, ndim=2)
%                Matriz de probabilidades de transização
%                trProbM(i,j) = Prob i -> j


%% Grid discretizado
a_bar = n_std * sqrt(pSigma^2 / (1 - pRho^2));

% Grid
y     = linspace(-a_bar, a_bar, N);

% Distância entre pontos
d     = y(2) - y(1);


%% Matriz de transição
trProbM  = zeros(N, N);

for iRow = 1 : N

   trProbM(iRow, 1) = normcdf((y(1) - pRho*y(iRow) + d/2) / pSigma);
   trProbM(iRow, N) = 1 - normcdf((y(N) - pRho*y(iRow) - d/2) / pSigma);

   % Preenche
   for iCol = 2 : N-1
      trProbM(iRow, iCol) = (normcdf((y(iCol) - pRho*y(iRow) + d/2) / pSigma) - ...
                             normcdf((y(iCol) - pRho*y(iRow) - d/2) / pSigma));
   end

end


%% Centrando Valor pela média do processo
y = y + pMu / (1 - pRho); 


end