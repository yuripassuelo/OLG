% Modelo de Gerações sobrepostas com Multiplos Periodos com Lifetime
% Incerta
% Yuri Passuelo
% 16/01/2024

%--------------------------------------------------------------------
%{
Nesse exercicios Usamos

1. $\sigma = 3.0$

2. Tabua de Mortalidade Jordan (1975)

3. Diferentes Níveis/Taxas de Crescimento populacional

4. 7 pontos de Choque Usando $\sigma_{\varepisilon} = 0.045$

5. Grid de tamanho 150 de k variando de 0 a 300


%}


%% Ambiente
clc;                     % Limpa tela
clear;                   % Limpa Memoria
close all;               % Fecha janela
addpath(genpath(pwd));   % Path de trabalho


%% Parâmetros fixos
cS             = ParameterValues_Fixed_2;

% Oferta de trabalho
[paramS.leLogGridV, paramS.leTrProbM, paramS.leProb1V] ...
               = EarningProcess_olgm(cS);
paramS.leGridV = exp(paramS.leLogGridV);

% Perfil de eficiencia (Aproveitamento) por idade
% Aproximação Linear de Huggett (1996) 

paramS.ageEffV = exp(log(0.5289)+log([linspace(0.3,1.25,12),linspace(1.3,1.5,6),linspace(1.5,1.5,11),linspace(1.49,1.05,11),linspace(1,0.1,9),linspace(0.08,0,5),zeros(1,cS.aD-54)]));

%% Resolve problema do HouseHold

% Step 1. Precomputa oferta agregada de trabalho, L. Since age efficiency is
%         fixed and there is no labor supply decision, L can be precalibrated 
%         without solving household problem
% Step 2. Chute para K e T
% Step 3. Dado chute computar preços R, w, e b
% Step 4. Dados preços R, w, b, e T, resolve problema do Holsehold e 
%         pega funções politicas
% Step 5. Dada solução do problema do Holsehold, computa K agregado e T 
% Step 6. devV = [KGuess - K; TGuess - T]
%         Se devV Esta acima do nível de tolerancia, Atualiza chute K e T,
%         e volta ao passo 2.



% Computa oferta de trabalho
eIdxM        = LaborEndowSimulation_olgm(cS, paramS);

[~, Lv1]       = LaborSupply_Huggett(eIdxM, cS.ageMassV , cS, paramS);
[~, Lv2]       = LaborSupply_Huggett(eIdxM, cS.ageMassV2, cS, paramS);
[~, Lv3]       = LaborSupply_Huggett(eIdxM, cS.ageMassV3, cS, paramS);

% Chutes para K e T
K            = 56.430264399364560;
T            = 0.902795718208179;

% Computa preços
[~, R, w, b] = HHPrices_Huggett(K, Lv1, cS);
bV           = [zeros(1, cS.aR), ones(1, cS.aD - cS.aR) .* b];

ageDeathMassV = cS.ageMassV .* cS.d;

% Equilibrio 1
[ Kv1, Tv1, cPolM1, kPolM1, valueM1 ] = FindEquilibrium( cS, paramS, K,Lv1,T, eIdxM, ageDeathMassV, cS.popGrowth );

% Equilibrrio 2

ageDeathMassV2 = cS.ageMassV2 .* cS.d;

[ Kv2, Tv2, cPolM2, kPolM2, valueM2 ] = FindEquilibrium( cS, paramS, K,Lv2,T, eIdxM, ageDeathMassV2, cS.popGrowth2 );

% Equilibrrio 3

ageDeathMassV3 = cS.ageMassV3 .* cS.d;

[ Kv3, Tv3, cPolM3, kPolM3, valueM3 ] = FindEquilibrium( cS, paramS, K,Lv3,T, eIdxM, ageDeathMassV3, cS.popGrowth3 );

% Age Death Mass

plot( ageDeathMassV )
hold on;
plot( ageDeathMassV2 )
plot( ageDeathMassV3 )
hold off;

% Age Mass

plot( cS.ageMassV  )
hold on;
plot( cS.ageMassV2 )
plot( cS.ageMassV3 )
hold off;

% Dependency Ratio

RM1 = cS.retireMass;
RM2 = cS.retireMass2;
RM3 = cS.retireMass3;

% Calculando Demais estatísticas

[Yv1, rv1, wv1, tauv1, bv1] = HHPrices_Huggett_v2( Kv1, Lv1, cS);
[Yv2, rv2, wv2, tauv2, bv2] = HHPrices_Huggett_v2( Kv2, Lv2, cS);
[Yv3, rv3, wv3, tauv3, bv3] = HHPrices_Huggett_v2( Kv3, Lv3, cS);

KYv1 = Kv1/Yv1;
KYv2 = Kv2/Yv2;
KYv3 = Kv3/Yv3;

% Simulando K prime

[kHistM1, ~]   = HHSimulation_olgm(kPolM1, cPolM1, eIdxM, cS);
[kHistM2, ~]   = HHSimulation_olgm(kPolM2, cPolM2, eIdxM, cS);
[kHistM3, ~]   = HHSimulation_olgm(kPolM3, cPolM3, eIdxM, cS);

kprimeHistM1   = [kHistM1(:,2:end), zeros(size(kHistM1,1),1)];
kprimeHistM2   = [kHistM2(:,2:end), zeros(size(kHistM2,1),1)];
kprimeHistM3   = [kHistM3(:,2:end), zeros(size(kHistM3,1),1)];

% Gini

Giniv1 = ComputeGini( reshape( kprimeHistM1, 1, [] ));
Giniv2 = ComputeGini( reshape( kprimeHistM2, 1, [] ));
Giniv3 = ComputeGini( reshape( kprimeHistM3, 1, [] ));

% Riqueza

W1_1  = ComputeTopWealth( reshape( kprimeHistM1, 1, [] ), 0.01 );    
W1_5  = ComputeTopWealth( reshape( kprimeHistM1, 1, [] ), 0.05 ); 
W1_20 = ComputeTopWealth( reshape( kprimeHistM1, 1, [] ), 0.2  ); 

W2_1  = ComputeTopWealth( reshape( kprimeHistM2, 1, [] ), 0.01 );    
W2_5  = ComputeTopWealth( reshape( kprimeHistM2, 1, [] ), 0.05 ); 
W2_20 = ComputeTopWealth( reshape( kprimeHistM2, 1, [] ), 0.2  );

W3_1  = ComputeTopWealth( reshape( kprimeHistM3, 1, [] ), 0.01 );    
W3_5  = ComputeTopWealth( reshape( kprimeHistM3, 1, [] ), 0.05 ); 
W3_20 = ComputeTopWealth( reshape( kprimeHistM3, 1, [] ), 0.2  );

% Compute Zero Wealth

W1_0 = CompZeroWealth( reshape( kprimeHistM1, 1, [] ) );
W2_0 = CompZeroWealth( reshape( kprimeHistM2, 1, [] ) );
W3_0 = CompZeroWealth( reshape( kprimeHistM3, 1, [] ) );

% Monta Tabela

Tabela_Resumo = table( ['1';'2';'3'], ...
                       [ cS.sigma, cS.popGrowth  , KYv1 , Tv1, Giniv1, W1_1, W1_5, W1_20, W1_0 ; ...
                         cS.sigma, cS.popGrowth2 , KYv2 , Tv2, Giniv2, W2_1, W2_5, W2_20, W2_0 ; ...
                         cS.sigma, cS.popGrowth3 , KYv3 , Tv3, Giniv3, W3_1, W3_5, W3_20, W3_0] );

writetable(Tabela_Resumo,'Results/ResultadosPrincipais_2.txt')


% Resultados Secundarios

% Capital, Trabalho, PIB agregado, Juros, Salarios e aposentadoria

Tabela_Secundaria = table( ["1";"2";"3"], ...
                           [ cS.sigma, cS.popGrowth , Yv1, Kv1, Lv1, rv1, wv1, tauv1, bv1; ... 
                             cS.sigma, cS.popGrowth2, Yv2, Kv2, Lv2, rv2, wv2, tauv2, bv2; ...
                             cS.sigma, cS.popGrowth3, Yv3, Kv3, Lv3, rv3, wv3, tauv3, bv3 ] );

writetable(Tabela_Secundaria,'Results/ResultadosSecundarios_2.txt')

% Gráficos

% Idade 23

figure;
h1 = subplot(1,3,1);
plot(cS.kGridV, cPolM1(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM2(:, 1, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM3(:, 1, 23), 'r', 'LineWidth', 1);
hold off
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
%title('Consumo ótimo na Idade 23 anos','Interpreter', 'latex')
title('z = 0.3679','Interpreter', 'latex')
legend('$\eta=0.012$', '$\eta=0.0$', '$\eta=-0.012$', 'Location', 'northwest','Interpreter', 'latex');


h2 = subplot(1,3,2);
plot(cS.kGridV, cPolM1(:, 4, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM3(:, 4, 23), 'r', 'LineWidth', 1);
hold off
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('z = 7.6176','Interpreter', 'latex')
legend('$\eta=0.012$', '$\eta=0.0$', '$\eta=-0.012$', 'Location', 'northwest','Interpreter', 'latex');


h3 = subplot(1,3,3);
plot(cS.kGridV, cPolM1(:, 7, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM2(:, 7, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('z = 157.7348', 'Interpreter', 'latex')
legend('$\eta=0.012$', '$\eta=0.0$', '$\eta=-0.012$', 'Location', 'northwest','Interpreter', 'latex');

fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/Plot_Geral_2.pdf','ContentType','vector')

% Versao da politica do Consumo


h1 = subplot(1,3,1);
plot(cS.kGridV, cPolM1(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 120])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = 0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');

h2 = subplot(1,3,2);
plot(cS.kGridV, cPolM2(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM2(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 120])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = 0.0$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');

h3 = subplot(1,3,3);
plot(cS.kGridV, cPolM3(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, cPolM3(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, cPolM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 120])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = -0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/Plot_Geral_2_v2.pdf','ContentType','vector')

% Versao politica - Poupanca



h1 = subplot(1,3,1);
plot(cS.kGridV, kPolM1(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, kPolM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, kPolM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 300])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = 0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');

h2 = subplot(1,3,2);
plot(cS.kGridV, kPolM2(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, kPolM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, kPolM2(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 300])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = 0.0$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');

h3 = subplot(1,3,3);
plot(cS.kGridV, kPolM3(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, kPolM3(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, kPolM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([0 300])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
title('$\eta = -0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'northeast','Interpreter', 'latex');


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/Plot_Geral_2_v3.pdf','ContentType','vector')

% Funcoes Valor

h1 = subplot(1,3,1);
plot(cS.kGridV, valueM1(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, valueM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, valueM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([-20 0])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
%title('Consumo ótimo na Idade 23 anos','Interpreter', 'latex')
title('$\eta = 0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'southeast','Interpreter', 'latex');

h2 = subplot(1,3,2);
plot(cS.kGridV, valueM2(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, valueM2(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, valueM2(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([-20 0])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
%title('Consumo ótimo na Idade 23 anos','Interpreter', 'latex')
title('$\eta = 0.0$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'southeast','Interpreter', 'latex');


h3 = subplot(1,3,3);
plot(cS.kGridV, valueM3(:, 1, 23), 'k', 'LineWidth', 1);
hold on
plot(cS.kGridV, valueM3(:, 4, 23), 'k--', 'LineWidth', 1);
plot(cS.kGridV, valueM3(:, 7, 23), 'r', 'LineWidth', 1);
hold off
ylim([-20 0])
xlabel('Wealth k','Interpreter', 'latex');
ylabel('c(k,e,23)','Interpreter', 'latex');
%title('Consumo ótimo na Idade 23 anos','Interpreter', 'latex')
title('$\eta = -0.012$','Interpreter', 'latex')
legend('$z=0.3679$', '$z=7.6176$', '$z=157.7348$', 'Location', 'southeast','Interpreter', 'latex');


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/Plot_Geral_2_v4.pdf','ContentType','vector')


% Exporta Dados


writematrix( kprimeHistM1 , 'Results/Data/Matriz_n1_2.dat')
writematrix( kprimeHistM2 , 'Results/Data/Matriz_n2_2.dat')
writematrix( kprimeHistM3 , 'Results/Data/Matriz_n3_2.dat')

