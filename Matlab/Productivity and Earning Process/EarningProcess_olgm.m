function [logGridV, trProbM, prob1V] = EarningProcess_olgm(cS)
%% Documentação:
% Calibra dotação de trabalho
% Idade liquida do perfil de eficiência.

% INPUTS: cS.
% (1). nw:            # Número de estados de Choque
% (2). lePersistence: Persistência do processo AR(1)
% (3). leShockStd:    Desvio padrão do componente aleatório do processo AR(1)
% (4). leWidth:       # of standard deviations the grid is wide
% (5). leSigma1:      Desvio padrão da distribuição normal que dotações de trabalho no período inicial seguem

% OUTPUTS:
% (1). logGridV: log grid dos estados
% (2). trProbM:  trProbM(i,j) = Prob i -> j (Matriz de Transição de
% estados)
% (3). prob1V:   Distribuição Estacionaria


%% Main
[logGridV, trProbM] = tauchen(cS.nw, cS.lePersistence, cS.leShockStd, 0, cS.leWidth);

% Agentes tem dotação aproximada por uma Log Normal dentro do grid
% aproximado por uma AR(1)
prob1V              = norm_grid(logGridV, logGridV(1)-2, logGridV(end)+2, 0, cS.leSigma1);
prob1V              = prob1V(:);

% Melhora Escala
logGridV            = logGridV(:) - logGridV(1) - 1;


%% Validação de Output
validateattributes(trProbM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
                   '<', 1, 'size', [cS.nw, cS.nw]});

pSumV = sum(trProbM, 2);
if any(abs(pSumV - 1) > 1e-6)
    error('probs do not sum to 1');
end

validateattributes(prob1V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
                   'size', [cS.nw, 1]});
             
if abs(sum(prob1V) - 1) > 1e-6
    error('prob1V does not sum to 1');
end


end