function [ ZeroWealthPerc ] = CompZeroWealth( x )

    % Size o vector
    n = length( x );

    x = x( x <= 1e-5 );

    ZeroWealthPerc  = length( x )/n;

end