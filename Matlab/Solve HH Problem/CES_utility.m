function [muM, utilM] = CES_utility(cM, sig)
%% Documentação
% Função de utilidade CES

%{
INPUTS:
(1). cM:    Consumo (Vetor de qualquer dimensão)
(2). sig:   Sigma. Curvature parameter
(3). dbg:   patâmetro de debug

OUTPUTS:
(1). muM:   utilidade marginal
(2). utilM: utilidade
%}


%%  Validação Input
% 1. Consumo não pode ser pequeno
if any(cM(:) < 1e-8)
    error('Cannot compute utility for very small consumption');
end

% 2. Sigma deve ser escalar
if length(sig) ~= 1
    error('sig must be scalar');
end

% 3. Sigma deve ser positivo
if sig <= 0
    error('sig must be > 0');
end


%% Computa Utilidade: log quando sig=1; CES quando sig>1
if sig == 1                            % Log utilidade
   utilM = log(cM);                    % Utilidade
   muM   = 1 ./ cM;                    % Utilidade Marginal
else
   utilM = cM .^ (1-sig) ./ (1-sig);   % Utilidade CES
   muM = cM .^ (-sig);                 % Utilidade Marginal
end


end