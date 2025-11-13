function eIdxM = MarkovChainSimulation(nSim, T, prob0V, trProbM, rvInM)
%% Documentação:
% Simula matriz de Markov

% INPUTS:
% (1). nSim:          Número de individuos simulados
% (2). T:             length of histories
%                     In a finite-period model (e.g. OLG), T is the total 
%                     age that we set households to live
% (3). prob0V:        Probabilidade no primeiro período 1
% (4). trProbM(s',s): Probabilidade de transição da matrix, que mostra a 
%                     prob do estado s transicionar para o s'
% (5). rvInM:         Variaveis aleatorias uniformes, por [ind, t]

% OUTPUT:
% eIdxM: Dotação de trabalho [ind, age]


%% Validação do Input
ns = length(prob0V);

% Checa número de inputs
if nargin ~= 5
   error('Invalid nargin');
end

validateattributes(trProbM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', '>=', 0, '<=', 1, 'size', [ns, ns]})

% Checando se a soma de probabilidades soma um
prSumV = sum(trProbM);
if max(abs( prSumV - 1 )) > 1e-5
    error('Probabilities do not sum to one');
end

validateattributes(prob0V(:), {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', '>=', 0, '<=', 1, 'size', [ns,1]})

if abs(sum(prob0V) - 1) > 1e-5
    error('Initial probs do not sum to 1');
end
               
validateattributes(rvInM, {'double', 'single'}, {'finite', 'nonnan', ...
                   'nonempty', 'real', '>=', 0, '<=', 1, 'size', [nSim, T]})


%% Preliminares
% Para cada estado, encontra a probabilidade cumulativa para o próximo
% período
cumTrProbM = cumsum(trProbM);
cumTrProbM(ns, :) = 1;

% Faz transposta da matriz de transição cumulativa [s, s']
cumTrProbM = cumTrProbM';


%%  Interagindo sobre as idades
eIdxM = zeros([nSim, T]);

% Desenha t=1
eIdxM(:, 1) = 1 + sum((rvInM(:,1) * ones(1, ns)) > (ones(nSim,1) * cumsum(prob0V(:)')), 2);

% Para t = 2, ..., T
for t = 1 : (T-1)
   eIdxM(:, t+1) = 1 + sum((rvInM(:,t+1) * ones(1, ns)) > cumTrProbM(eIdxM(:,t), :), 2);
end


end