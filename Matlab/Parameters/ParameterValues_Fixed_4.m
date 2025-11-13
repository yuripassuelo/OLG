function cS = ParameterValues_Fixed
%% Parametrização do Modelo


%% ************************ Demografia ************************
cS.age1       = 20;     % Idade Inicial (Consideramos aqui a idade inicial igual à 20
cS.ageLast    = 98;     % Idade Máxima
cS.ageRetire  = 65;     % Idade de aposentadoria (65 anos)
cS.popGrowth  = 0.012;  % Population growth rate (Caso 1)
cS.popGrowth2 = 0.0;    % Caso 2
cS.popGrowth3 = -0.012; % Caso 3


% Model age
cS.aD        = cS.ageLast - cS.age1 + 1;
cS.aR        = cS.ageRetire - cS.age1 + 1;

% Probabilidades de Sobrevivência

% Baseado em Jordan, C., Life contingencies, 2nd ed. (Society of Actuaries).
% Probabilidade Condicional de t = 20 até 98

% Fonte: Actuarial Life Table - Social Security (2021)
% https://www.ssa.gov/oact/STATS/table4c6.html

cS.d         = [ 0.000507, 0.000556, 0.000610, 0.000666, 0.000722, 0.000775, 0.000831, 0.000889, 0.000952, 0.001025, ...
                 0.001104, 0.001192, 0.001289, 0.001383, 0.001465, 0.001544, 0.001626, 0.001719, 0.001824, 0.001940, ...
                 0.002066, 0.002202, 0.002351, 0.002482, 0.002622, 0.002789, 0.002994, 0.003219, 0.003467, 0.003729, ...
                 0.004011, 0.004306, 0.004634, 0.004981, 0.005370, 0.005831, 0.006326, 0.006837, 0.007399, 0.008033, ...
                 0.008687, 0.009411, 0.010139, 0.010849, 0.011550, 0.012216, 0.012952, 0.013844, 0.014863, 0.016028, ...
                 0.017329, 0.018859, 0.020609, 0.022620, 0.024958, 0.027906, 0.030925, 0.034140, 0.037620, 0.041725, ...
                 0.046324, 0.051334, 0.056911, 0.063279, 0.070704, 0.079184, 0.088697, 0.099240, 0.110480, 0.123078, ...
                 0.137152, 0.152605, 0.169494, 0.187623, 0.206647, 0.225890, 0.245054, 0.263815, 0.281828 ];

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
cS.kMin          = 0;          % % Capital Minimo
cS.kMax          = 300;        % Valor Máximo
kGridV           = linspace(cS.kMin, cS.kMax, cS.nk); 
cS.kGridV        = kGridV(:);  % Vetor Linha de Capital


end