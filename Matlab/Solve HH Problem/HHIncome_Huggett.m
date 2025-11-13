function incomeM = HHIncome_Huggett(kV, R, w, T, b, a, paramS, cS)
%% Documentation:
% Computa renda dado uma idade
% Renda do Household = Renda proveniente do trabalho e beneficios + Renda do Capital

% INPUTS
% (1). kV:      grid de capital, é um vetor (nk x 1)
% (2). R and w: prices faced by households
%               R = 1+ (MPK - ddk )(1 - impostos )
%               w = MPL(1 - impostos - Aposentadoria)
% (3). T:       Transferências acidentais
% (4). b:       Beneficios de seguridade social
% (4). a:       Idade

% OUTPUT
% incomeM: renda do household em uma idade
%          é uma matriz (nk x nw)


%% Renda (por choque)
% nonCapIncomeV: vetor (nw x 1)

% renda do trabalho em uma idade depende apenas do estado exogeno
% variavel e, realização da dotação.

% Hence for each working HH, nonCapIncomeV is a (nw x 1) vector, each
% element corresponding to each labor endowment realization

% Para holseholds aposentados, a>aR, tem mesma renda nao proveniente do capital 
% Vetor de renda nao proveniente do capital (nw x 1) . mas nesse caso, cada
% elemento em nonCapIncomeV toma o mesmo valor
    
if a <= cS.aR
   nonCapIncomeV = paramS.ageEffV(a) .* w .* paramS.leGridV + T;
else
   nonCapIncomeV = b .* ones([cS.nw, 1]) + T;
end


%% Renda Total em uma dada idade
% incomeM é uma matrix (nk x nw)
%     k_1 + nw tipos de renda do trabalho
%     k_2 + nw tipos de renda do trabalho
%         ...      ...
%     k_nk + nw tipos de renda do trabalho

incomeM = R * kV(:) * ones([1, cS.nw]) + ones([length(kV),1]) * nonCapIncomeV(:)';


end