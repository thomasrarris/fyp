clearvars -except w

R = 1;                      %transmission rate in bits/slot (same for every SBS)
B = 1;                      %size of videos

C = 800;                    %cache size
K = 10000;                  %number of videos considered
Vunsrt = zipf(K, w);        %probabilities of videos
p = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
a = 0;                      %array with users' mobility status - purely mobile 

T_max = 10;                 %threshold delay to ensure fairness
T_avg = 2;                  %threshold average delay to ensure quality
bit = B/N;                  %size of each bit
CB = C/B;

figure('position', [500 500 300 300])

%% delay aware algorith based solution
results = zeros(K,2);
chi = zeros(K,1);

initial = min(K, T_max * C);

chiStar = 1/T_max;            %the minimum amount of cached data necessary to ensure the fairness requirement
chi(1:initial) = ones(initial,1) * chiStar;

count = 1;
while getAvgDelay(K, chi, p) > T_avg

    found1 = true;
    for k = K:-1:1
        if chi(k)>0 && found1
            pointer = k;
            found1 = false;
            g = chi(k);
            chi(k) = 0;
        end
    end

    V = Vunsrt(chi>0)';
    V = V/sum(V);
    K1 = size(V,1);

    preprocessing;
    delayAwareAlgV2;
    chi = [ chi1 ; zeros(K-K1,1)];
    
    results(count,:) = [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )];
    [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )]
    count = count + 1;
end

results = results(results(:,1)>0,:);
plot(results(:,1),results(:,2), 'LineWidth', 2);

%% most popular files benchmark
results = zeros(K,2);
chi = zeros(K,1);

initial = min(K, T_max * C);

chiStar = 1/T_max;            %the minimum amount of cached data necessary to ensure the fairness requirement
chi(1:initial) = ones(initial,1) * chiStar;

count = 1;
while getAvgDelay(K, chi, p) > T_avg

    found1 = true;
    for k = K:-1:1
        if chi(k)>0 && found1
            pointer = k;
            found1 = false;
            g = chi(k);
            chi(k) = 0;
        end
    end

    chi1 = chi(chi>0);
    V = Vunsrt(chi>0)';
    V = V/sum(V);
    K1 = size(V,1);

    counter = 1;
    while g > 0
        
        if abs(chi1(counter) - 1) > 10^(-5)
            chi1(counter) = chi1(counter) + g;
            g = 0;
        end
        counter = counter + 1;
    end

    chi = [ chi1 ; zeros(K-K1,1)];
    
    results(count,:) = [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )];
    [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )]
    count = count + 1;
end

results = results(results(:,1)>0,:);
hold on
plot(results(:,1),results(:,2), 'LineWidth', 2);
hold off

%% equal file caching
V = Vunsrt';
preprocessing

results = zeros(K,2);
chi = zeros(K,1);

initial = min(K, T_max * C);

chiStar = 1/T_max;            %the minimum amount of cached data necessary to ensure the fairness requirement
chi(1:initial) = ones(initial,1) * chiStar;

count = 1;
while getAvgDelay(K, chi, p) > T_avg

    found1 = true;
    for k = K:-1:1
        if chi(k)>0 && found1
            pointer = k;
            found1 = false;
            g = chi(k);
            chi(k) = 0;
        end
    end

    chi1 = chi(chi>0);
    V = Vunsrt(chi>0)';
    V = V/sum(V);
    K1 = size(V,1);

    l = 1;
    chi1 = ones(K1,1) * (1 / T_max) * DL(l);
    CB = C/B - sum(chi1);

    while CB > 0

        if CB >= K1 * (DL(l+1)-DL(l)) * chiStar
            chi1(:,1) = chi1(:,1) + (DL(l+1)-DL(l)) * chiStar;
            CB = CB - K1 * (DL(l+1)-DL(l)) * chiStar;
            l = l + 1;
        else
            counter = 1;
            while CB > 0
                if CB >= (DL(l+1)-DL(l)) * chiStar
                    chi1(counter,1) = chi1(counter,1) + (DL(l+1)-DL(l)) * chiStar;
                    counter = counter + 1;
                    CB = CB - (DL(l+1)-DL(l)) * chiStar;
                else
                    chi1(counter,1) = chi1(counter,1) + CB;
                    CB = 0;
                end
            end
        end
    end

    chi = [ chi1 ; zeros(K-K1,1)];
    
    results(count,:) = [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )];
    [getAvgDelay(K, chi, p) lossFunction( K, p, chi, a )]
    count = count + 1;
end

results = results(results(:,1)>0,:);
hold on
plot(results(:,1),results(:,2), 'LineWidth', 2);
hold off
%% graph
xlabel('D_{avgMax} (in time slots)')
ylabel('Average cost normalised over file size')
xlim([T_avg,8]);
ylim([0,0.45]);
set(gca,'fontsize',12)
% title(strcat('Cost versus max avg delay for  a=0, w=', num2str(w),', T=10'))
legend('Delay Aware Caching','Caching Most Popular files', 'Caching files equally')
print(strcat('mobileUser', extractAfter(num2str(w), '0.')),'-depsc')