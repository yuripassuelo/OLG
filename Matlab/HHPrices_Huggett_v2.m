function [Y, r, w1, tau, b] = HHPrices_Huggett_v2( K, L, cS)

%% Main
% Production
Y   = cS.A * (K^cS.alpha) * (L^(1-cS.alpha));
MPK = cS.alpha * cS.A * (K^(cS.alpha-1)) * (L^(1-cS.alpha));
MPL = (1-cS.alpha) * cS.A * (K^cS.alpha) * (L^(-cS.alpha));

r = MPK;
w1 = MPL;
% Tax
tau = 0.195/(1-cS.ddk * K/Y);

% Prices faced by households
R   = 1 + (MPK - cS.ddk)*(1 - tau);
w   = MPL*(1 - tau - cS.theta);

% Social security benefits
b   = cS.theta * w * L/cS.retireMass;

end