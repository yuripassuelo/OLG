function [Y, R, w, b] = HHPrices_Huggett(K, L, cS)
%% Documentação;
% Função baseada em uma função de produção

% INPUTS
% (1). K:        Capital Agregado
% (2). L:        Oferta Agregada de Trabalho
% (3). cS.A:     Produtividade
% (4). cS.alpha: Share do Capital
% (5). cS.ddk:   Taxa de depreciação
% (6). cS.theta: Taxa de seguridade social
% (7). cS.retireMass: Massa de individuos aposentados

% OUTPUTS
% (1). Y: Produto Agregado
% (2). R: Preço de Aluguel do Capital enfrentado pelos Household
%         R = 1+ (MPK - ddk )(1 - impostos )
% (3). w: Salarios após Impostos
%         w = MPL(1 - tax - SeguridadeSocial )
% (4). b: Beneficio de Seguridade Social
%         (SeguridadeSocial x w x L) = b x IndividuosAposentados

% ******************* Nota ******************* 
% Impostos Calibrados de acordo com
% 0.195/(1-d ddk x K/Y)


%% Principaç
% Produto e Produtos Marginais
Y   = cS.A * (K^cS.alpha) * (L^(1-cS.alpha));
MPK = cS.alpha * cS.A * (K^(cS.alpha-1)) * (L^(1-cS.alpha));
MPL = (1-cS.alpha) * cS.A * (K^cS.alpha) * (L^(-cS.alpha));

% Impostos
tau = 0.195/(1-cS.ddk * K/Y);

% Preços Enfrentados pelo HouseHold
R   = 1 + (MPK - cS.ddk)*(1 - tau);
w   = MPL*(1 - tau - cS.theta);

% Beneficios de Seguridade Social
b   = cS.theta * w * L/cS.retireMass;


end