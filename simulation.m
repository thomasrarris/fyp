clear 

R = 1;                      %transmission rate in bits/slot (same for every SBS)
B = 1;                      %size of videos
K = 10000;                  %number of videos considered
w = 0.95;                   %skewness coefficient
Vunsrt = zipf(K, w);     %probabilities of videos
V = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
T_max = 10;                 %threshold delay to ensure fairness

bit = B/N;                  %size of each bit

%% Graph Parameters

step = 500;
maxCacheSize = 5000;

figure('position', [500 500 400 400])
%% Calculate gamma values

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

clear previous limit 
%% implementation of the algorithm derived in the paper

tic
for i = 0:step:maxCacheSize

    Dk = ones(K,1) * DLstar;
    gammak = abs(GAMMA(:,1));
    lk = ones(K,1);
    CB = i;
    dl = gamma(2,:);

    while CB > 0
        [MAX, k] = max(gammak);

        if CB >= dl(lk(k) + 1) - dl(lk(k))
            CB = CB - (dl(lk(k) + 1) - dl(lk(k)));
            Dk(k) = dl(lk(k) + 1);
            lk(k) = lk(k) + 1;
            gammak(k) = abs(GAMMA(k,lk(k)));
        else 
            Dk(k) = Dk(k) + CB;
            CB = 0;
        end
    end

    avrage_delay(i/step + 1) = V' * ceil(1./Dk);
    cache_size(i/step + 1) =  (K * DLstar * bit + i) / K;
end

plot(cache_size, avrage_delay)

%% most popular videos benchmark

for i = 0:step:maxCacheSize

C = i;
    
Dk = ones(K,1) * 1 / T_max;
CB = C;

counter = 1;
while CB > 0
    
    if CB >= 1 - 1/T_max
        Dk(counter) = 1;
        CB = CB - (1 - 1/T_max);
        counter = counter + 1;
    else 
        Dk(counter) = Dk(counter) + CB;
        CB = 0;
    end
    
end

avrage_delay(i/step + 1) = V' * ceil(1./Dk);
cache_size(i/step + 1) =  (K * DLstar * bit + i) / K;
end

hold on 
plot(cache_size, avrage_delay)
hold off

%% equal size caching

for i = 0:step:maxCacheSize
  
    l = 1;
    Dk = ones(K,1) * (1 / T_max) * DL(l);
    CB = i;


    while CB > 0

        if CB >= K * (DL(l+1)-DL(l)) * 1/T_max
            Dk(:,1) = Dk(:,1) + (DL(l+1)-DL(l)) * 1/T_max;
            CB = CB - K * (DL(l+1)-DL(l)) * 1/T_max;
            l = l + 1;
        else
            counter = 1;
            while CB > 0
                if CB >= (DL(l+1)-DL(l)) * 1/T_max
                    Dk(counter,1) = Dk(counter,1) + (DL(l+1)-DL(l)) * 1/T_max;
                    counter = counter + 1;
                    CB = CB - (DL(l+1)-DL(l)) * 1/T_max;
                    
                else
                    Dk(counter,1) = Dk(counter,1) + CB;
                    CB = 0;
                end
            end
        end
    end

    avrage_delay(i/step + 1) = V' * ceil(1./Dk);
    cache_size(i/step + 1) =  (K * DLstar * bit + i) / K;
end

hold on 
plot(cache_size, avrage_delay)
hold off

xlabel('Cache Size (in terms of video library size)')
ylabel('Average Buffering Delay (in time slots)')
title('Delay versus Cache Size for w=0.85, T=10')
xlim([0 0.5])
legend('Delay Aware Caching','Caching Most Popular files', 'Caching files equally')
print(strcat('cs', num2str(w)),'-depsc')

toc

clear i MAX step Vunsrt