    function [ K, T, cPolM, kPolM, valueM ] = FindEquilibrium( cS, paramS, K, L, T, eIdxM, aDMV, PopG )
    
    % Tolerância e Iteração Máxima
    tol      = 1e-5;
    max_it   = 100; 
    
    % Distância
    max_dist = 10;

    % Iteração
    it = 0;

    % Lambda
    lambda = 0.98;

    % Backward Induction
    while max_dist >= tol && it < max_it
        % Iteracao
        it = it + 1;

        % Calcula Precos
        [~, R, w, b] = HHPrices_Huggett(K, L, cS);
        bV           = [zeros(1, cS.aR), ones(1, cS.aD - cS.aR) .* b];

        % Computa função Política
        [cPolM, kPolM, valueM] ...
             = HHSolution_VFI_Huggett(R, w, T, bV, paramS, cS);

        % Simulação
        [kHistM, ~]   = HHSimulation_olgm(kPolM, cPolM, eIdxM, cS);
        
        % Capital Novo
        K1        = mean(kHistM,1) * cS.ageMassV'; 
        K1        = max(0.01, K1);

        % Transfer and accidental bequests
        kprimeHistM   = [kHistM(:,2:end), zeros(size(kHistM,1),1)];
        % ageDeathMassV = cS.ageMassV .* cS.d;

        % Transferências
        T1            = (mean(kprimeHistM * R, 1) * aDMV') / (1 - PopG );

        max_dist      = max([ abs(K - K1) , abs(T - T1)]);

        disp([ it, max_dist ]);

        % Corrige valorrres
        K = (lambda^it)*K + (1-(lambda^it))*K1 ;
        T = (lambda^it)*T + (1-(lambda^it))*T1 ;
    
    end






end