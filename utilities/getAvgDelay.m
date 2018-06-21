function [ avgDelay ] = getAvgDelay( K, gamma, p )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

avgDelay = 0;
for k = 1:K
    if gamma(k) > 0
        avgDelay = avgDelay + p(k) * ceil(1/gamma(k));
        
    else
       % avgDelay = avgDelay + p(k) * D;
    end

end

end

