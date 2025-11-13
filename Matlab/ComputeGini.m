function [ GINI ] = ComputeGini( x )

    % Ordenando o vetor
    x = sort( x );
    % Pesos do vetor
    weights = ones([ 1 length( x ) ])/length(x);

    p  = cumsum( weights );
    nu = cumsum( weights .* x );
    n  = length( nu );
    nu = nu/nu(n);

    GINI = sum(nu(2:end) .* p(1:(n-1))) - sum(nu(1:(n-1)) .* p(2:end));

end