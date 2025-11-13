function [c, kPrime, ValueFunc] = HHSolutionByOneState_VFI_Huggett_v2(a, y, R, vPrimeOfK, cS)
%% Documentação:
% Função retorna funções politica e função valor dado estado (ik, ie, a), usando
% Iteração da função valor
%--------------------------------------------------------------------------

% Restrição orçamentaria: k' = y - c

% INPUTS:
% (1). a:           idade atual
% (2). y:           renda atual, dado estado (ik, ie)
% (3). R:           preço de aluguel do capital encontrado pelo household
% (4). vPrimeOfK:   valor esperado no proximo periodo
%                   é uma função de kPrime, com um grid interpolado


%% Main
% kprime factiveis - Kprime nao pode consumir toda poupança
kPrimeMax = min(cS.kGridV(cS.nk), y - cS.cFloor);

if kPrimeMax <= cS.kGridV(1)
   % Sem escolha factivel. Household consome o c minimo
   kPrime   = cS.kGridV(1);

   ValueFunc = CES_utility( y - kPrime, cS.sigma) + cS.beta*cS.s(a) * R * vPrimeOfK( kPrime );

   c = y - kPrime;
   
else
   % Vetor de Consumos que sejam pelo menos tao grandes quanto c_floor
   Cons = (y - cS.kGridV).*( y - cS.kGridV >= cS.cFloor ) + cS.cFloor.*(y - cS.kGridV < cS.cFloor ).*( cS.kGridV > kPrimeMax ) ;

   % Constroi Consumo
   Utility  = CES_utility( Cons, cS.sigma) + cS.beta*cS.s(a) * R * vPrimeOfK( cS.kGridV ) ;

   % Filtra utlidade e pega a maxima
   [ ValueFunc , max_ind ] = max( Utility );

   kPrime = cS.kGridV( max_ind );

   c = y - kPrime;
   
end


%% Validação de Output
validateattributes(kPrime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
                   '>=', cS.kGridV(1) - 1e-6, '<=', kPrimeMax + 1e-6})

validateattributes(c, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
                   '>=', cS.cFloor - 1e-6})

validateattributes(ValueFunc, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})





end