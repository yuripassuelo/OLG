function cS = ParameterValues_Fixed
%% Parametrização do Modelo


%% ************************ Demografia ************************ 
cS.age1       = 20;     % Idade Inicial (Consideramos aqui a idade inicial igual à 20
cS.ageLast    = 98;     % Idade Máxima
cS.ageRetire  = 65;     % Idade de aposentadoria (65 anos)
cS.popGrowth  = 0.012;  % Taxa de Crescimento Populacional (Caso 1)
cS.popGrowth2 = 0.0;    % Caso 2
cS.popGrowth3 = -0.012; % Caso 3


% Idades Modelo
cS.aD        = cS.ageLast - cS.age1 + 1;
cS.aR        = cS.ageRetire - cS.age1 + 1;

% Probabilidades de Sobrevivência

% Baseado em Jordan, C., Life contingencies, 2nd ed. (Society of Actuaries).
% Probabilidade Condicional de t = 20 até 98
cS.d         = [0.00159, 0.00169, 0.00174, 0.00172, 0.00165, 0.00156, 0.00149, 0.00145, 0.00145, 0.00149,...
                0.00156, 0.00163, 0.00171, 0.00181, 0.00193, 0.00207, 0.00225, 0.00246, 0.00270, 0.00299,...
                0.00332, 0.00368, 0.00409, 0.00454, 0.00504, 0.00558, 0.00617, 0.00686, 0.00766, 0.00865,...
                0.00955, 0.01058, 0.01162, 0.01264, 0.01368, 0.01475, 0.01593, 0.01730, 0.01891, 0.02074,...
                0.02271, 0.02476, 0.02690, 0.02912, 0.03143, 0.03389, 0.03652, 0.03930, 0.04225, 0.04538,...
                0.04871, 0.05230, 0.05623, 0.06060, 0.06542, 0.07066, 0.07636, 0.08271, 0.08986, 0.09788,...
                0.10732, 0.11799, 0.12895, 0.13920, 0.14861, 0.16039, 0.17303, 0.18665, 0.20194, 0.21877,...
                0.23601, 0.25289, 0.26973, 0.28612, 0.30128, 0.31416, 0.32915, 0.34450, 0.36018]; 

% Probabilidade de Morte (Literalmente 1 - Probabilidade de Sobrevivência)
cS.s         = 1 - cS.d;
% Massa de Households por Idade (Padronizada)
cS.ageMassV   = ones(1, cS.aD);
cS.ageMassV2  = ones(1, cS.aD);
cS.ageMassV3  = ones(1, cS.aD);

for i = 2 : length(cS.ageMassV)
    cS.ageMassV(i) = cS.s(i-1) * cS.ageMassV(i-1) / (1 + cS.popGrowth);
    cS.ageMassV2(i) = cS.s(i-1) * cS.ageMassV2(i-1) / (1 + cS.popGrowth2);
    cS.ageMassV3(i) = cS.s(i-1) * cS.ageMassV3(i-1) / (1 + cS.popGrowth3);
end
cS.ageMassV   = cS.ageMassV./sum(cS.ageMassV);
cS.ageMassV2  = cS.ageMassV2./sum(cS.ageMassV2);
cS.ageMassV3  = cS.ageMassV3./sum(cS.ageMassV3);

% Massa de Aposentados
cS.retireMass  = sum(cS.ageMassV(cS.aR + 1 : end));
cS.retireMass2 = sum(cS.ageMassV2(cS.aR + 1 : end));
cS.retireMass3 = sum(cS.ageMassV3(cS.aR + 1 : end));

% Physical age for each model age
cS.physAgeV   = (cS.age1 : cS.ageLast)';


%% ****************************** Household *******************************
cS.sigma      = 3.0;   % Aversão relativa ao Risco
cS.beta       = 1.011; % Desconto Intertemporal
cS.cFloor     = 0.05;  % Consumo Minimo
cS.nSim       = 5e4;   % Número de simulações realizada


%% ****************************** Tecnologia ****************************** 
cS.A          = 0.895944; % Produtividade total dos fatores
cS.alpha      = 0.36;     % Parcela da renda detida pelo Capital
cS.ddk        = 0.06;     % Depreciação


%% *************************** Seguridade Social ****************************
cS.theta      = 0.1; % Impostos de seguridade social sobre trabalho


%% *************************** Dotação de trabalho ****************************
cS.leSigma1      = 0.38 ^ 0.5;
cS.leShockStd    = 0.045 .^ 0.5; % Variância do Choque
cS.lePersistence = 0.96;         % Persistência do Choque
cS.leWidth       = 4;            % Numero de desvios padrões para construção do vetor
cS.nw            = 7;            % Quantidade de Pontos do vetor de choque

%% ******************************* Grids **********************************
% Capital grid
cS.tgKY          = 3;          % Target da razão Capital Produto
cS.tgWage        = (1-cS.alpha)*cS.A*((cS.tgKY/cS.A)^(cS.alpha/(1-cS.alpha)));
cS.nk            = 150;        % Número de pontos
cS.kMin          = 0;          % Capital Minimo
cS.kMax          = 300;        % Valor Máximo
kGridV           = linspace(cS.kMin, cS.kMax, cS.nk); % Grid Linearmente espaçado
cS.kGridV        = kGridV(:);  % Vetor Linha de Capital


end