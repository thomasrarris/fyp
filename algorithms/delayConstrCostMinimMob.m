function [ results, chi ] = delayConstrCostMinimMob( Vunsrt, p, C, B, T_max, T_avg, alpha )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    K = size( Vunsrt, 2 );
    results = zeros(K,2);
    chi = zeros(K,1);

    initial = min(K, T_max * C);

    chiStar = 1/T_max;            %the minimum amount of cached data necessary to ensure the fairness requirement
    chi(1:initial) = ones(initial,1) * chiStar;

    CB = C/B;
    
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

        [ gamma, GAMMA, DLstar ] = preprocess( V, T_max );
        chi1 = delayAwareAlgorithm( V, DLstar, GAMMA, gamma, CB );
        chi = [ chi1 ; zeros(K-K1,1)];

        results(count,:) = [getAvgDelay(K, chi, p) cost( K, p, chi, alpha )];
        [getAvgDelay(K, chi, p) cost( K, p, chi, alpha )];
        count = count + 1;
    end

    results = results(results(:,1)>0,:);

end

