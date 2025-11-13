function [ PercWealth ] = ComputeTopWealth( x , p )
    % Total Wealth
    sum_x = sum( x );

    sub_x = x( x >= quantile( x, 1 - p ));

    PercWealth = sum( sub_x )/ sum_x;

end