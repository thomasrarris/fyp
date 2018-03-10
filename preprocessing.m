%precomputation for algorithm
DLstar = 1/T_max;      

DL(1) = 1;      %delay levels
previous = T_max;
counter = 2;
for i = 1:T_max    
    if previous > ceil(T_max/i)
        previous = ceil(T_max/i);
        DL(counter) = i;
        counter = counter + 1;
    end
end

counter = 1;
for Dk = DL  
    Rk(counter) = ceil(T_max/Dk);
    counter = counter + 1;
end

limit = size(DL,2);
for i = 1: limit - 1
    gamma(1, i) = (Rk(i + 1) - Rk(i))/(DL(i+1) - DL(i));
    gamma(2, i) = DL(i);
end

gamma(1, limit) = 0; %(Rk(Dk) - tempy)/(Dk - tempx);
gamma(2, limit) = DL(limit);
gamma(2, :) = gamma(2, :)/T_max;

GAMMA = V * gamma(1,:);

clear previous limit Dk