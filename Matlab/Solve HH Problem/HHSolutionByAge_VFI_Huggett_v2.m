function [cPolM, kPolM, valueM] = HHSolutionByAge_VFI_Huggett_v2(a, vPrime_keM, R, w, T, b, paramS, cS)
%% Documentação:
% Essa função resolve o problema household para uma determinada idade
% ***************************************************************


% INPUTS:
% (1). a:               idade
% (2). vPrimeM(ik, ie): função valor na idade a+1
%                       ignotada se a = aD
% (3). R, w:            preços enfrentados pelos households
% (4). T:               Transferencias lump sum acidentais
% (5). b:               Seguridade social na idade a

% OUTPUTS:
% cPolM, kPolM: Funções politicas, indexadas por [ik, ie]
% valueM:       Funções valor, indexadas por [ik, ie]


%% Checar Input
if a < cS.aD
    if ~isequal(size(vPrime_keM), [cS.nk, cS.nw])
        error('Invalid size of cPrimeM');
    end
end


%% Main
% Renda y na idade a
% yM é uma matriz (nk x nw) :
yM               = HHIncome_Huggett(cS.kGridV, R, w, T, b, a, paramS, cS);

if a == cS.aD
   % Nesse caso consome toda renda e não salva nada
   cPolM       = yM;
   kPolM       = zeros(cS.nk, cS.nw);
   [~, valueM] = CES_utility(cPolM, cS.sigma);
   
else
   % Vetores para alocar valores
   cPolM       = zeros(cS.nk, cS.nw);
   kPolM       = zeros(cS.nk, cS.nw);
   valueM      = zeros(cS.nk, cS.nw);

   % Loop sobre estados [ik, ie]
   for ie = 1 : cS.nw
       
      % Valor esperado, pelo kPrime -- EV(k')
      % ExValuePrimeV é um vetor (nk x 1), para cada capital, o valor
      % esperado sobre todas as dotações de trabalaho no proximo periodo
      ExValuePrimeV = zeros(cS.nk, 1);
      for ik = 1 : cS.nk
         ExValuePrimeV(ik) = paramS.leTrProbM(ie,:) * vPrime_keM(ik,:)';
      end

      % Aproximaçao continua de EV(k')
      % vPrimeOfK é uma função aproxima a relação discreta entre 
      % parmaS.kGridV e ExValuePrimeV usando interpolação linear. 
      vPrimeOfK = griddedInterpolant(cS.kGridV, ExValuePrimeV, 'linear');

      % Loop sobre capital
      for ik = 1 : cS.nk
            [cPolM(ik,ie), kPolM(ik,ie), valueM(ik,ie)] = ...
                  HHSolutionByOneState_VFI_Huggett_v2(a, yM(ik,ie), R, vPrimeOfK, cS);
      end % for ik

   end % for ie

end % Loop idade


%% Output Validation
validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', 'positive', 'size', [cS.nk, cS.nw]})

%validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
%                   '>=', cS.kMin - 1e-6,  '<=', cS.kGridV(cS.nk) + 1e-6, ...
%                   'size', [cS.nk, cS.nw]})

validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                   '>=', cS.kMin - 1e-6,  '<=', cS.kMax + 1e-6, ...
                   'size', [cS.nk, cS.nw]})

validateattributes(valueM, {'double'}, {'finite', 'nonnan', 'nonempty', ...
                   'real', 'size', [cS.nk, cS.nw]})


end