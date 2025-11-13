
% Limpa Ambiente

clc;                     % Clear screen
clear;                   % Clear memory
close all;               % Close open windows
addpath(genpath(pwd));

% Importa dados de matrizes

kprimeHistM1_1 = readmatrix( "Results/Data/Matriz_n1_1.dat");
kprimeHistM2_1 = readmatrix( "Results/Data/Matriz_n2_1.dat");
kprimeHistM3_1 = readmatrix( "Results/Data/Matriz_n3_1.dat");

kprimeHistM1_2 = readmatrix( "Results/Data/Matriz_n1_2.dat");
kprimeHistM2_2 = readmatrix( "Results/Data/Matriz_n2_2.dat");
kprimeHistM3_2 = readmatrix( "Results/Data/Matriz_n3_2.dat");

kprimeHistM1_3 = readmatrix( "Results/Data/Matriz_n1_3.dat");
kprimeHistM2_3 = readmatrix( "Results/Data/Matriz_n2_3.dat");
kprimeHistM3_3 = readmatrix( "Results/Data/Matriz_n3_3.dat");

kprimeHistM1_4 = readmatrix( "Results/Data/Matriz_n1_4.dat");
kprimeHistM2_4 = readmatrix( "Results/Data/Matriz_n2_4.dat");
kprimeHistM3_4 = readmatrix( "Results/Data/Matriz_n3_4.dat");


%

% Constroi Bases
gini_vecM1_1 = zeros([ 1 79 ]);
gini_vecM2_1 = zeros([ 1 79 ]);
gini_vecM3_1 = zeros([ 1 79 ]);

gini_vecM1_2 = zeros([ 1 79 ]);
gini_vecM2_2 = zeros([ 1 79 ]);
gini_vecM3_2 = zeros([ 1 79 ]);

gini_vecM1_3 = zeros([ 1 79 ]);
gini_vecM2_3 = zeros([ 1 79 ]);
gini_vecM3_3 = zeros([ 1 79 ]);

gini_vecM1_4 = zeros([ 1 79 ]);
gini_vecM2_4 = zeros([ 1 79 ]);
gini_vecM3_4 = zeros([ 1 79 ]);

for i = 1:79

    gini_vecM1_1(1,i) = ComputeGini( kprimeHistM1_1(:,i)' );
    gini_vecM2_1(1,i) = ComputeGini( kprimeHistM2_1(:,i)' );
    gini_vecM3_1(1,i) = ComputeGini( kprimeHistM3_1(:,i)' );

    gini_vecM1_2(1,i) = ComputeGini( kprimeHistM1_2(:,i)' );
    gini_vecM2_2(1,i) = ComputeGini( kprimeHistM2_2(:,i)' );
    gini_vecM3_2(1,i) = ComputeGini( kprimeHistM3_2(:,i)' );

    gini_vecM1_3(1,i) = ComputeGini( kprimeHistM1_3(:,i)' );
    gini_vecM2_3(1,i) = ComputeGini( kprimeHistM2_3(:,i)' );
    gini_vecM3_3(1,i) = ComputeGini( kprimeHistM3_3(:,i)' );

    gini_vecM1_4(1,i) = ComputeGini( kprimeHistM1_4(:,i)' );
    gini_vecM2_4(1,i) = ComputeGini( kprimeHistM2_4(:,i)' );
    gini_vecM3_4(1,i) = ComputeGini( kprimeHistM3_4(:,i)' );

    %

end


% Faz Gráficos


idades = linspace( 20, 98, 79 );


h1 = subplot(1,3,1);

plot(idades, gini_vecM1_1, 'LineWidth', 1.5 )
hold on
plot(idades, gini_vecM1_2, 'LineWidth', 1.5 )
plot(idades, gini_vecM1_3, 'LineWidth', 1.5 )
plot(idades, gini_vecM1_4, 'LineWidth', 1.5 )
hold off
title("$\eta=-0.012$","Interpreter","latex")
ylabel("GINI", "Interpreter", "latex")
xlabel("Idade","Interpreter", "latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);


plot(idades, gini_vecM2_1, 'LineWidth', 1.5 )
hold on
plot(idades, gini_vecM2_2, 'LineWidth', 1.5 )
plot(idades, gini_vecM2_3, 'LineWidth', 1.5 )
plot(idades, gini_vecM2_4, 'LineWidth', 1.5 )
hold off
title("$\eta=0.0$","Interpreter","latex")
xlabel("Idade","Interpreter", "latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);

plot(idades, gini_vecM3_1, 'LineWidth', 1.5 )
hold on
plot(idades, gini_vecM3_2, 'LineWidth', 1.5 )
plot(idades, gini_vecM3_3, 'LineWidth', 1.5 )
plot(idades, gini_vecM3_4, 'LineWidth', 1.5 )
hold off
title("$\eta=0.012$","Interpreter","latex")
legend("$\sigma=1.5$, Jordan (1975)","$\sigma=3.0$, Jordan (1975)", ...
       "$\sigma=1.5$, Social Security (2021)","$\sigma=3.0$, Social Security (2021)","Interpreter","latex", ...
       'NumColumns',2,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])
xlabel("Idade","Interpreter", "latex")

h3.Position = [0.6916, 0.25, 0.25, 0.65];

% Posicao Legenda

fig=gcf;
fig.Position(3:4)=[700,300];


exportgraphics(gcf,'Plots/PlotWealth_1.pdf','ContentType','vector')



% Parte 2 Olhando Riqueza Media, Mediana e Quantis

% Vetores - 1

vec_w_meanM1_1 = zeros( [1 79]);
vec_w_medM1_1  = zeros( [1 79]);
vec_w_10M1_1   = zeros( [1 79]);
vec_w_25M1_1   = zeros( [1 79]);

vec_w_meanM2_1 = zeros( [1 79]);
vec_w_medM2_1  = zeros( [1 79]);
vec_w_10M2_1   = zeros( [1 79]);
vec_w_25M2_1   = zeros( [1 79]);

vec_w_meanM3_1 = zeros( [1 79]);
vec_w_medM3_1  = zeros( [1 79]);
vec_w_10M3_1   = zeros( [1 79]);
vec_w_25M3_1   = zeros( [1 79]);

% Vetores - 2

vec_w_meanM1_2 = zeros( [1 79]);
vec_w_medM1_2  = zeros( [1 79]);
vec_w_10M1_2   = zeros( [1 79]);
vec_w_25M1_2   = zeros( [1 79]);

vec_w_meanM2_2 = zeros( [1 79]);
vec_w_medM2_2  = zeros( [1 79]);
vec_w_10M2_2   = zeros( [1 79]);
vec_w_25M2_2   = zeros( [1 79]);

vec_w_meanM3_2 = zeros( [1 79]);
vec_w_medM3_2  = zeros( [1 79]);
vec_w_10M3_2   = zeros( [1 79]);
vec_w_25M3_2   = zeros( [1 79]);

% Vetores - 3

vec_w_meanM1_3 = zeros( [1 79]);
vec_w_medM1_3  = zeros( [1 79]);
vec_w_10M1_3   = zeros( [1 79]);
vec_w_25M1_3   = zeros( [1 79]);

vec_w_meanM2_3 = zeros( [1 79]);
vec_w_medM2_3  = zeros( [1 79]);
vec_w_10M2_3   = zeros( [1 79]);
vec_w_25M2_3   = zeros( [1 79]);

vec_w_meanM3_3 = zeros( [1 79]);
vec_w_medM3_3  = zeros( [1 79]);
vec_w_10M3_3   = zeros( [1 79]);
vec_w_25M3_3   = zeros( [1 79]);

% Vetores - 4

vec_w_meanM1_4 = zeros( [1 79]);
vec_w_medM1_4  = zeros( [1 79]);
vec_w_10M1_4   = zeros( [1 79]);
vec_w_25M1_4   = zeros( [1 79]);

vec_w_meanM2_4 = zeros( [1 79]);
vec_w_medM2_4  = zeros( [1 79]);
vec_w_10M2_4   = zeros( [1 79]);
vec_w_25M2_4   = zeros( [1 79]);

vec_w_meanM3_4 = zeros( [1 79]);
vec_w_medM3_4  = zeros( [1 79]);
vec_w_10M3_4   = zeros( [1 79]);
vec_w_25M3_4   = zeros( [1 79]);


for i = 1:79

    vec_w_meanM1_1(1,i) = mean( kprimeHistM1_1(:,i) )  ;
    vec_w_medM1_1(1,i)  = median( kprimeHistM1_1(:,i) )  ;
    vec_w_10M1_1(1,i)   = quantile( kprimeHistM1_1(:,i), .1 )  ;
    vec_w_25M1_1(1,i)   = quantile( kprimeHistM1_1(:,i), .25 )  ;

    vec_w_meanM2_1(1,i) = mean( kprimeHistM2_1(:,i) )  ;
    vec_w_medM2_1(1,i)  = median( kprimeHistM2_1(:,i) )  ;
    vec_w_10M2_1(1,i)   = quantile( kprimeHistM2_1(:,i), .1 )  ;
    vec_w_25M2_1(1,i)   = quantile( kprimeHistM2_1(:,i), .25 )  ;

    vec_w_meanM3_1(1,i) = mean( kprimeHistM3_1(:,i) )  ;
    vec_w_medM3_1(1,i)  = median( kprimeHistM3_1(:,i) )  ;
    vec_w_10M3_1(1,i)   = quantile( kprimeHistM3_1(:,i), .1 )  ;
    vec_w_25M3_1(1,i)   = quantile( kprimeHistM3_1(:,i), .25 )  ;

    % 2

    vec_w_meanM1_2(1,i) = mean( kprimeHistM1_2(:,i) )  ;
    vec_w_medM1_2(1,i)  = median( kprimeHistM1_2(:,i) )  ;
    vec_w_10M1_2(1,i)   = quantile( kprimeHistM1_2(:,i), .1 )  ;
    vec_w_25M1_2(1,i)   = quantile( kprimeHistM1_2(:,i), .25 )  ;

    vec_w_meanM2_2(1,i) = mean( kprimeHistM2_2(:,i) )  ;
    vec_w_medM2_2(1,i)  = median( kprimeHistM2_2(:,i) )  ;
    vec_w_10M2_2(1,i)   = quantile( kprimeHistM2_2(:,i), .1 )  ;
    vec_w_25M2_2(1,i)   = quantile( kprimeHistM2_2(:,i), .25 )  ;

    vec_w_meanM3_2(1,i) = mean( kprimeHistM3_2(:,i) )  ;
    vec_w_medM3_2(1,i)  = median( kprimeHistM3_2(:,i) )  ;
    vec_w_10M3_2(1,i)   = quantile( kprimeHistM3_2(:,i), .1 )  ;
    vec_w_25M3_2(1,i)   = quantile( kprimeHistM3_2(:,i), .25 )  ;

    % 3

    vec_w_meanM1_3(1,i) = mean( kprimeHistM1_3(:,i) )  ;
    vec_w_medM1_3(1,i)  = median( kprimeHistM1_3(:,i) )  ;
    vec_w_10M1_3(1,i)   = quantile( kprimeHistM1_3(:,i), .1 )  ;
    vec_w_25M1_3(1,i)   = quantile( kprimeHistM1_3(:,i), .25 )  ;

    vec_w_meanM2_3(1,i) = mean( kprimeHistM2_3(:,i) )  ;
    vec_w_medM2_3(1,i)  = median( kprimeHistM2_3(:,i) )  ;
    vec_w_10M2_3(1,i)   = quantile( kprimeHistM2_3(:,i), .1 )  ;
    vec_w_25M2_3(1,i)   = quantile( kprimeHistM2_3(:,i), .25 )  ;

    vec_w_meanM3_3(1,i) = mean( kprimeHistM3_3(:,i) )  ;
    vec_w_medM3_3(1,i)  = median( kprimeHistM3_3(:,i) )  ;
    vec_w_10M3_3(1,i)   = quantile( kprimeHistM3_3(:,i), .1 )  ;
    vec_w_25M3_3(1,i)   = quantile( kprimeHistM3_3(:,i), .25 )  ;

    % 4

    vec_w_meanM1_4(1,i) = mean( kprimeHistM1_4(:,i) )  ;
    vec_w_medM1_4(1,i)  = median( kprimeHistM1_4(:,i) )  ;
    vec_w_10M1_4(1,i)   = quantile( kprimeHistM1_4(:,i), .1 )  ;
    vec_w_25M1_4(1,i)   = quantile( kprimeHistM1_4(:,i), .25 )  ;

    vec_w_meanM2_4(1,i) = mean( kprimeHistM2_4(:,i) )  ;
    vec_w_medM2_4(1,i)  = median( kprimeHistM2_4(:,i) )  ;
    vec_w_10M2_4(1,i)   = quantile( kprimeHistM2_4(:,i), .1 )  ;
    vec_w_25M2_4(1,i)   = quantile( kprimeHistM2_4(:,i), .25 )  ;

    vec_w_meanM3_4(1,i) = mean( kprimeHistM3_4(:,i) )  ;
    vec_w_medM3_4(1,i)  = median( kprimeHistM3_4(:,i) )  ;
    vec_w_10M3_4(1,i)   = quantile( kprimeHistM3_4(:,i), .1 )  ;
    vec_w_25M3_4(1,i)   = quantile( kprimeHistM3_4(:,i), .25 )  ;

end


% Plots Parte 2

% Distribuição de Riqueza para diferentes taxas de Crescimento - 1

h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_1,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM1_1 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M1_1, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M1_1, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
title("$\eta = -0.012$", "Interpreter", "latex")
ylabel("Riqueza","Interpreter","latex")
xlabel("Idade","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_1,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM2_1 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M2_1, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M2_1, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_1,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM3_1 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M3_1, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M3_1, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

legend("Media", "Mediana", "Quantil 10\%", "Quantil 25\%","Interpreter","latex", ...
       'NumColumns',4,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];

fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealthStats_1.pdf','ContentType','vector')

% Distribuição de Riqueza para diferentes taxas de Crescimento - 2


h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_2,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM1_2 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M1_2, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M1_2, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = -0.012$", "Interpreter", "latex")
ylabel("Riqueza","Interpreter","latex")
xlabel("Idade","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_2,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM2_2 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M2_2, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M2_2, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_2,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM3_2 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M3_2, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M3_2, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

legend("Media", "Mediana", "Quantil 10\%", "Quantil 25\%","Interpreter","latex", ...
       'NumColumns',4,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];

fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealthStats_2.pdf','ContentType','vector')

% Distribuição de Riqueza para diferentes taxas de Crescimento - 3


h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_3,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM1_3 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M1_3, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M1_3, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = -0.012$", "Interpreter", "latex")
ylabel("Riqueza","Interpreter","latex")
xlabel("Idade","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_3,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM2_3 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M2_3, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M2_3, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_3,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM3_3 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M3_3, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M3_3, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

legend("Media", "Mediana", "Quantil 10\%", "Quantil 25\%","Interpreter","latex", ...
       'NumColumns',4,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];

fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealthStats_3.pdf','ContentType','vector')

% Distribuição de Riqueza para diferentes taxas de Crescimento - 4


h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_4,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM1_4 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M1_4, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M1_4, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = -0.012$", "Interpreter", "latex")
ylabel("Riqueza","Interpreter","latex")
xlabel("Idade","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_4,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM2_4 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M2_4, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M2_4, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_4,'Color',[0,0,0],'LineStyle', '-', 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_medM3_4 ,'Color',[0.38,0.36,0.36], 'LineStyle', '--', 'LineWidth',1.5 )
plot( idades, vec_w_10M3_4, 'Color',[0.48,0.45,0.45],'LineStyle', ":", 'LineWidth',1.5 )
plot( idades, vec_w_25M3_4, 'Color',[0.82,0.8,0.79],'LineStyle', "-.", 'LineWidth',1.5 )
hold off;
ylim([0 100])
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

legend("Media", "Mediana", "Quantil 10\%", "Quantil 25\%","Interpreter","latex", ...
       'NumColumns',4,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];

fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealthStats_4.pdf','ContentType','vector')


% Criando Gráfico da Riqueza Média por Idade para diferentes cenario


h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM1_4, 'LineWidth',1.5 )
hold off;
title("$\eta = -0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
ylabel("Riqueza","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM2_4, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM3_4, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
legend("Jordan (1975)","Social Security (2021)","Interpreter","latex", ...
       'NumColumns',2,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealth_3.pdf','ContentType','vector')



% Ultimos plots



h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_1, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM1_3, 'LineWidth',1.5 )
hold off;
title("$\eta = -0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
ylabel("Riqueza","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_1, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM2_3, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_1, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM3_3, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
legend("Jordan (1975)","Social Security (2021)","Interpreter","latex", ...
       'NumColumns',2,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealth_2.pdf','ContentType','vector')



h1 = subplot(1,3,1);
plot( idades, vec_w_meanM1_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM1_4, 'LineWidth',1.5 )
hold off;
title("$\eta = -0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
ylabel("Riqueza","Interpreter","latex")

h1.Position = [0.1300, 0.25, 0.25, 0.65];

h2 = subplot(1,3,2);
plot( idades, vec_w_meanM2_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM2_4, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.0$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")

h2.Position = [0.4108, 0.25, 0.25, 0.65];

h3 = subplot(1,3,3);
plot( idades, vec_w_meanM3_2, 'LineWidth',1.5 )
hold on;
plot( idades, vec_w_meanM3_4, 'LineWidth',1.5 )
hold off;
title("$\eta = 0.012$", "Interpreter", "latex")
xlabel("Idade","Interpreter","latex")
legend("Jordan (1975)","Social Security (2021)","Interpreter","latex", ...
       'NumColumns',2,'Location', 'south', 'FontSize', 9, ...
       'Position',[0.256855448721915,0.029448028673835,0.546393250345342,0.111000002288818])

h3.Position = [0.6916, 0.25, 0.25, 0.65];


fig=gcf;
fig.Position(3:4)=[700,300];

exportgraphics(gcf,'Plots/PlotWealth_3.pdf','ContentType','vector')


% Computando Riqueza detida prlo 1, 5 e 20%

% Vetores:

vec_w_t1_M1_1  = zeros( [1 79]);
vec_w_t5_M2_1  = zeros( [1 79]);
vec_w_t20_M3_1 = zeros( [1 79]);

vec_w_t1_M1_2  = zeros( [1 79]);
vec_w_t5_M2_2  = zeros( [1 79]);
vec_w_t20_M3_2 = zeros( [1 79]);

vec_w_t1_M1_3  = zeros( [1 79]);
vec_w_t5_M2_3  = zeros( [1 79]);
vec_w_t20_M3_3 = zeros( [1 79]);

vec_w_t1_M1_4  = zeros( [1 79]);
vec_w_t5_M2_4  = zeros( [1 79]);
vec_w_t20_M3_4 = zeros( [1 79]);


for i = 1:79
    
    % 1
    vec_w_t1_M1_1(1,i)  = ComputeTopWealth( kprimeHistM1_1(:,i), 0.01 );
    vec_w_t5_M1_1(1,i)  = ComputeTopWealth( kprimeHistM1_1(:,i), 0.05 );
    vec_w_t20_M1_1(1,i) = ComputeTopWealth( kprimeHistM1_1(:,i), 0.20 );

    vec_w_t1_M2_1(1,i)  = ComputeTopWealth( kprimeHistM2_1(:,i), 0.01 );
    vec_w_t5_M2_1(1,i)  = ComputeTopWealth( kprimeHistM2_1(:,i), 0.05 );
    vec_w_t20_M2_1(1,i) = ComputeTopWealth( kprimeHistM2_1(:,i), 0.20 );

    vec_w_t1_M3_1(1,i)  = ComputeTopWealth( kprimeHistM3_1(:,i), 0.01 );
    vec_w_t5_M3_1(1,i)  = ComputeTopWealth( kprimeHistM3_1(:,i), 0.05 );
    vec_w_t20_M3_1(1,i) = ComputeTopWealth( kprimeHistM3_1(:,i), 0.20 );

    % 2
    vec_w_t1_M1_2(1,i)  = ComputeTopWealth( kprimeHistM1_2(:,i), 0.01 );
    vec_w_t5_M1_2(1,i)  = ComputeTopWealth( kprimeHistM1_2(:,i), 0.05 );
    vec_w_t20_M1_2(1,i) = ComputeTopWealth( kprimeHistM1_2(:,i), 0.20 );

    vec_w_t1_M2_2(1,i)  = ComputeTopWealth( kprimeHistM2_2(:,i), 0.01 );
    vec_w_t5_M2_2(1,i)  = ComputeTopWealth( kprimeHistM2_2(:,i), 0.05 );
    vec_w_t20_M2_2(1,i) = ComputeTopWealth( kprimeHistM2_2(:,i), 0.20 );

    vec_w_t1_M3_2(1,i)  = ComputeTopWealth( kprimeHistM3_2(:,i), 0.01 );
    vec_w_t5_M3_2(1,i)  = ComputeTopWealth( kprimeHistM3_2(:,i), 0.05 );
    vec_w_t20_M3_2(1,i) = ComputeTopWealth( kprimeHistM3_2(:,i), 0.20 );

    % 3
    vec_w_t1_M1_3(1,i)  = ComputeTopWealth( kprimeHistM1_3(:,i), 0.01 );
    vec_w_t5_M1_3(1,i)  = ComputeTopWealth( kprimeHistM1_3(:,i), 0.05 );
    vec_w_t20_M1_3(1,i) = ComputeTopWealth( kprimeHistM1_3(:,i), 0.20 );

    vec_w_t1_M2_3(1,i)  = ComputeTopWealth( kprimeHistM2_3(:,i), 0.01 );
    vec_w_t5_M2_3(1,i)  = ComputeTopWealth( kprimeHistM2_3(:,i), 0.05 );
    vec_w_t20_M2_3(1,i) = ComputeTopWealth( kprimeHistM2_3(:,i), 0.20 );

    vec_w_t1_M3_3(1,i)  = ComputeTopWealth( kprimeHistM3_3(:,i), 0.01 );
    vec_w_t5_M3_3(1,i)  = ComputeTopWealth( kprimeHistM3_3(:,i), 0.05 );
    vec_w_t20_M3_3(1,i) = ComputeTopWealth( kprimeHistM3_3(:,i), 0.20 );


    % 4
    vec_w_t1_M1_4(1,i)  = ComputeTopWealth( kprimeHistM1_4(:,i), 0.01 );
    vec_w_t5_M1_4(1,i)  = ComputeTopWealth( kprimeHistM1_4(:,i), 0.05 );
    vec_w_t20_M1_4(1,i) = ComputeTopWealth( kprimeHistM1_4(:,i), 0.20 );

    vec_w_t1_M2_4(1,i)  = ComputeTopWealth( kprimeHistM2_4(:,i), 0.01 );
    vec_w_t5_M2_4(1,i)  = ComputeTopWealth( kprimeHistM2_4(:,i), 0.05 );
    vec_w_t20_M2_4(1,i) = ComputeTopWealth( kprimeHistM2_4(:,i), 0.20 );

    vec_w_t1_M3_4(1,i)  = ComputeTopWealth( kprimeHistM3_4(:,i), 0.01 );
    vec_w_t5_M3_4(1,i)  = ComputeTopWealth( kprimeHistM3_4(:,i), 0.05 );
    vec_w_t20_M3_4(1,i) = ComputeTopWealth( kprimeHistM3_4(:,i), 0.20 );

end



plot( vec_w_t1_M1_1 )
hold on;
plot( vec_w_t1_M1_2 )
plot( vec_w_t1_M1_3 )
plot( vec_w_t1_M1_4 )
hold off;


plot( vec_w_t5_M1_1 )
hold on;
plot( vec_w_t5_M1_2 )
plot( vec_w_t5_M1_3 )
plot( vec_w_t5_M1_4 )
hold off;



plot( vec_w_t20_M1_1 )
hold on;
plot( vec_w_t20_M1_2 )
plot( vec_w_t20_M1_3 )
plot( vec_w_t20_M1_4 )
hold off;





% Plots Finais

