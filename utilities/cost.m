function result = cost( K, p, Mk, alpha )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cost_static = 0;
cost_mobile = 0;
for k = 1:K
    if Mk(k) == 0
        cost_mobile = cost_mobile + p(k);
    end
    
    if abs(Mk(k)-1) > 10^-10
        cost_static = cost_static +  p(k);
    end

end 

result =  alpha * cost_mobile + (1 - alpha) * cost_static;

end

