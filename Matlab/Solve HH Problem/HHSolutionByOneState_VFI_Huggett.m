function [c, kPrime, ValueFunc] = HHSolutionByOneState_VFI_Huggett(a, y, R, vPrimeOfK, fminbndOptS, cS)
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
% (5). fminbndOptS: opções para otimização (buscando c ótima)


%% Main
% kprime factiveis
kPrimeMax = min(cS.kGridV(cS.nk), y - cS.cFloor);

if kPrimeMax <= cS.kGridV(1)
   % Sem escolha factivel. Household consome o c minimo
   kPrime = cS.kGridV(1);
   
else
   % Encontra kPrime ótimo
   [kPrime, ~, ~] = fminbnd(@Bellman, cS.kGridV(1), kPrimeMax, fminbndOptS);
   
end

[ValueFunc, c] = Bellman(kPrime);
ValueFunc      = -ValueFunc;


%% Validação de Output
validateattributes(kPrime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
                   '>=', cS.kGridV(1) - 1e-6, '<=', kPrimeMax + 1e-6})

validateattributes(c, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
                   '>=', cS.cFloor - 1e-6})

validateattributes(ValueFunc, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})


%% Nested: objective function

% RHS da eq de Bellman x (-1)
% Já que:
% c = argmin -(RHS da eq de Bellman), que é equivalente
% c = argmax RHS da eq de Bellman

    function [Valfunc, c] = Bellman(kPrime)
        c       = max(cS.cFloor, y - kPrime);
        [~, u]  = CES_utility(c, cS.sigma);
        Valfunc = -(u + cS.beta *cS.s(a)* R * vPrimeOfK(kPrime));
    end


end