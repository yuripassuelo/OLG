function [massV, lbV, ubV] = norm_grid(xV, xMin, xMax, mu, sig)
%% Documentação:

% Approxima uma distribuição Normal em um Grid
% Dada uma distribuição Normal com parametros mu, sig e um grid de pontos
% (xV), Retorna a massa ao redor de xV 
% Implica que N(mu, sig^2) aonde é a distribuição Normal é truncada ao longo de [xMin, xMax]
% Funciona bem apenas se o grid é suficientemente denso!

% INPUTS:
% (1). xV:   Grid de Pontos
% (2). xMin: lower bound of smallest interval
% (3). xMax: upper bound of largest  interval
% (4). mu:   mean of the normal distribution
% (5). sig:  standard deviation of the normal distribution
      
% OUTPUTS:
% (1). massV: Massa no Grid
% (2). lbV:   Intervalo Inferior
% (3). ubV:   Intervalo Superior


%% Validação de Input

% 1. Valida número de Inputs
if nargin ~= 5
   error([ mfilename, ': Invalid nargin' ]);
end

n = length(xV);

% 2. Checa se xV é crescente
if any( xV(2:n) < xV(1:n-1) )
    warnmsg([ mfilename, ':  xV not increasing' ]);
    keyboard;
end

% 3. Checa se xMin é o menor valor em xV, e se xMax é o maior em xV
if xMin > xV(1)  ||  xMax < xV(n)
    warnmsg([ mfilename, ':  Invalid xMin or xMax' ]);
    keyboard;
end

% 4. Checa se mu se posiciona entre xMin e xMax
if mu < xMin  ||  mu > xMax
    warnmsg([ mfilename, ':  Invalid mu' ]);
    keyboard;
end


%% Main
% Construct interval boundaries
% Symmetric around xV
xMidV = 0.5 .* (xV(1:n-1) + xV(2:n));
lbV   = [xMin; xMidV(:)];
ubV   = [xMidV(:); xMax];

% Find mass in each interval
cdfV  = normcdf( [xMin; ubV], mu, sig );
massV = cdfV(2:(n+1)) - cdfV(1:n);
massV = massV(:) ./ sum(massV);


%% Checando Outputs
validateattributes(massV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
                   '>=', 0, '<=', 1});

validateattributes(lbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
                   '>=', xMin, '<=', xMax});

validateattributes(ubV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
                   '>=', xMin, '<=', xMax});

if any(ubV < lbV)
    error('ubV < lbV');
end
 

end