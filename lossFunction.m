function [ cost ] = lossFunction( K, p, gamma, a )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cost_static = 0;
cost_mobile = 0;
for k = 1:K
    if gamma(k) == 0
        cost_mobile = cost_mobile + p(k);
    else
        cost_static = cost_static + a * p(k) * (1 - gamma(k));
    end

end 

cost =  cost_static + cost_mobile;

end

