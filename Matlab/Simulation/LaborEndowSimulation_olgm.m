function eIdxM = LaborEndowSimulation_olgm(cS, paramS)
%% Documentação:
% Simula dotação de trabalho para um Coorte de idades


% OUTPUT:
% eIdxM: dotação de trabalho por [ind, age]
%        Aonde é uma matriz (nSim x age) matrix

%% Main

% Seta semente aleat´roai
rng(433);

% Dotação por [ind, age]
eIdxM = MarkovChainSimulation(cS.nSim, cS.aD, paramS.leProb1V, ...
                              paramS.leTrProbM', rand([cS.nSim, cS.aD]));
                          
end