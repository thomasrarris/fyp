function [ gamma, GAMMA, mlmin ] = preprocess( V, D_max )

    mlmin = 1/D_max;      

    ml(1) = 1; 
    previous = D_max;
    counter = 2;
    for i = 1:D_max    
        if previous > ceil(D_max/i)
            previous = ceil(D_max/i);
            ml(counter) = i;
            counter = counter + 1;
        end
    end

    counter = 1;
    for Mk = ml  
        Rk(counter) = ceil(D_max/Mk);
        counter = counter + 1;
    end

    limit = size(ml,2);
    for i = 1: limit - 1
        gamma(1, i) = (Rk(i + 1) - Rk(i))/(ml(i+1) - ml(i));
        gamma(2, i) = ml(i);
    end

    gamma(1, limit) = 0;                
    gamma(2, limit) = ml(limit);
    gamma(2, :) = gamma(2, :)/D_max;
    GAMMA = V * gamma(1,:);
end

