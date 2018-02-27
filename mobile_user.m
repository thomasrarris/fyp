clear 

R = 1;                      %transmission rate in bits/slot (same for every SBS)
B = 1;                      %size of videos

C = 800;                    %cache size
K = 10000;                  %number of videos considered
Vunsrt = zipf(K, 0.85);     %probabilities of videos
p = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
a = 0;                      %array with users' mobility status - purely mobile 

T = 10;                     %threshold delay to ensure fairness
Tavg = 3;                   %threshold average delay to ensure quality
bit = B/N;                  %size of each bit

%%

for Tavg = 2:10
    gamma = zeros(K,1);

    initial = min(K, T * C);

    gammaStar = 1/T;            %the minimum amount of cached data necessary to ensure the fairness requirement
    gamma(1:initial) = ones(initial,1) * gammaStar;

    while getAvgDelay(K, gamma, p) > Tavg

        found1 = true;

        for k = K:-1:1
            if gamma(k)>0 && found1

                found1 = false;
                g = gamma(k);
                gamma(k) = 0;

                found2 = true;
                for i = 1:K
                    if gamma(i) < 0.9 && found2 
                        gamma(i) = gamma(i) + g;
                        found2 = false;
                    end
                end

            end
        end      
    end

    cost(Tavg-1) = lossFunction( K, p, gamma, a );
    tavg(Tavg-1) = Tavg;

end

plot(tavg, cost);
xlabel('T_{avg} constraint')
ylabel('Cost')
title('Cost versus average delay constraint for  a=0, w=0.85, T=10')
