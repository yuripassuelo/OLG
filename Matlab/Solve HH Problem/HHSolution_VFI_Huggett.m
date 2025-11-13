function [cPolM, kPolM, valueM] = HHSolution_VFI_Huggett(R, w, T, bV, paramS, cS)
%% Documentação:
% Função resolve problema do household 

% INPUTS:
% (1). R, w:       Preços enfrentados pelo holsehold, R=1+r
% (2). T:          Transferências lump sum de ativos por morte acidental
% (3). bV:         Beneficio aposentadoria
%                  vetor de dimensão (aD x 1): 
%                  para holsehold com idade 1~aR, aposentadoria é 0
%                  para holsehold com idade aR+1~aD, aposentadoria é b
% (4). paramS, cS: other parameters

% OUTPUTS:
% (1). cPolM:  função politica do consumo por estado [ik, ie, age]
% (2). kPolM:  função politica da poupança por estado [ik, ie, age]
% (3). valueM: função valor em cada estado [ik, ie, age]


%% Main
% Inicializa função valor e politica
cPolM  = zeros(cS.nk, cS.nw, cS.aD);
kPolM  = zeros(cS.nk, cS.nw, cS.aD);
valueM = zeros(cS.nk, cS.nw, cS.aD);

% Backward induction

for a = cS.aD : -1 : 1

   % Função valor do proximo periodo
   if a < cS.aD
      vPrimeM = valueM(:,:,a+1);
   else
   % Quando a=aD é o ultimo periodo e portanto não tem próximo período
      vPrimeM = [];
   end

   [cPolM(:,:,a), kPolM(:,:,a), valueM(:,:,a)] = ...
      HHSolutionByAge_VFI_Huggett(a, vPrimeM, R, w, T, bV(a), paramS, cS);
  
end


%% Validar output
validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', 'positive', 'size', [cS.nk, cS.nw, cS.aD]})

validateattributes(valueM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', 'size', [cS.nk, cS.nw, cS.aD]})

validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', 'size', [cS.nk, cS.nw, cS.aD], ...
                   '>=', cS.kMin - 1e-6, '<=', cS.kGridV(end) + 1e-6})


end