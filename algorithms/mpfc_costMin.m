function [ results, chi ] = mpfc_costMin( C, T_max, T_avg, p, Vunsrt, alpha )

    K = size( Vunsrt, 2 );
    
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

        results(count,:) = [getAvgDelay(K, chi, p) cost( K, p, chi, alpha )];
        [getAvgDelay(K, chi, p) cost( K, p, chi, alpha )];
        count = count + 1;
    end

    results = results(results(:,1)>0,:);

end

