clear 

R = 1;                      %transmission rate in bits/slot (same for every SBS)
B = 1;                      %size of videos
K = 10000;                  %number of videos considered
Vunsrt = zipf(K, 0.85);    %probabilities of videos
V = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
T = 10;                     %threshold delay to ensure fairness

bit = B/N;                  %size of each bit

%% Graph Parameters

step = 250;
maxCacheSize = 5000;

%% Calculate gamma values

Dk = 1:N;

DLstar = min(Dk(ceil(N./Dk) <= T));

Rk = zeros(1, N);

gamma = zeros(1,2);
gammaCounter = 1;

tempx = DLstar;
tempy = ceil(N/DLstar);

for Dk = DLstar : N   
    Rk(Dk) = ceil(N/Dk);
    
    if tempy ~= Rk(Dk)
        gamma(1, gammaCounter) = (Rk(Dk) - tempy)/(Dk - tempx);
        gamma(2, gammaCounter) = tempx;
        gamma(3, gammaCounter) = Dk/N - DLstar/N;
        
        tempy = Rk(Dk);
        tempx = Dk;
        gammaCounter = gammaCounter + 1;
    end
end

gamma(1, gammaCounter) = 0; %(Rk(Dk) - tempy)/(Dk - tempx);
gamma(2, gammaCounter) = tempx;
gamma(3,2:end) = gamma(3,2:end) - gamma(3,1:end-1);

GAMMA = V * gamma(1,:);

%% implementation of the algorithm derived in the paper

tic
for i = 0:step:maxCacheSize

C = i;
    
Dk = ones(K,1) * DLstar;
gammak = abs(GAMMA(:,1));
lk = ones(K,1);
CB = C;
DL = gamma(2,:);

while CB > 0
    [MAX, k] = max(gammak);
    
    if lk(k) + 1 <= size(DL,2) 
        if CB >= DL(lk(k) + 1) - DL(lk(k))
            CB = CB - (DL(lk(k) + 1) - DL(lk(k))) * bit;
            Dk(k) = DL(lk(k) + 1);
            lk(k) = lk(k) + 1;
            gammak(k) = abs(GAMMA(k,lk(k)));
        else 
            Dk(k) = Dk(k) + CB;
            CB = 0;
        end
    else 
        Dk(k) = Dk(k) + CB;
        CB = 0;
    end
    
end

avrage_delay(i/step + 1) = V' * ceil(N./Dk);
cache_size(i/step + 1) =  (K * DLstar * bit + i) / K;
end

plot(cache_size, avrage_delay)

%% most popular videos benchmark

for i = 0:step:maxCacheSize

C = i;
    
Dk = ones(K,1) * DLstar / N;
CB = C;

counter = 1;
while CB > 0
    
    if CB >= (N-DLstar) / N
        Dk(counter) = Dk(counter) + (N-DLstar) / N;
        CB = CB - (N-DLstar) / N;
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
    
Dk = ones(K,1) * DLstar / N;
CB = i;
stages = gamma(3, 1:end);

counter = 1;
while CB > 0
    
    if CB >= K * stages(counter)
        Dk(:,1) = Dk(:,1) + stages(counter);
        CB = CB - K * stages(counter);
    else 
        for j = 1 : CB/stages(counter)
            Dk(j) = Dk(j) + stages(counter);
        end
        CB = 0;
    end
    
    counter = counter + 1;
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
legend('Delay Aware Caching','Caching Most Popular files', 'Caching files equally')
toc

