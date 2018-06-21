function [ results, Mk ] = efc_costMin( Vunsrt, p, C, B, T_max, T_avg, alpha )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    
    V = Vunsrt';
    [ gamma, GAMMA, DLstar ] = preprocess( V, T_max );
    DL = gamma(2,:);
    
    K = size( V, 1 );
    results = zeros(K,2);
    Mk = zeros(K,1);

    initial = min(K, T_max * C);

    Mk(1:initial) = ones(initial,1) * DLstar;

    count = 1;
    while getAvgDelay(K, Mk, p) > T_avg

        index = size(Mk(Mk>0),1);
        Mk(index) = 0;

        Mk1 = Mk(1:index-1);
        V = Vunsrt(1:index-1)';
        V = V/sum(V);
        K1 = size(V,1);

        l = 1;
        Mk1 = ones(K1,1) * DLstar;
        CB = C/B - sum(Mk1);

        while CB > 0

            if CB >= K1 * (DL(l+1)-DL(l))
                Mk1(:,1) = Mk1(:,1) + (DL(l+1)-DL(l));
                CB = CB - K1 * (DL(l+1)-DL(l));
                l = l + 1;
            else
                counter = 1;
                while CB > 0
                    if CB >= (DL(l+1)-DL(l))
                        Mk1(counter,1) = Mk1(counter,1) + (DL(l+1)-DL(l));
                        counter = counter + 1;
                        CB = CB - (DL(l+1)-DL(l));
                    else
                        Mk1(counter,1) = Mk1(counter,1) + CB;
                        CB = 0;
                    end
                end
            end
        end

        Mk = [ Mk1 ; zeros(K-K1,1)];

        results(count,:) = [getAvgDelay(K, Mk, p) cost( K, p, Mk, alpha )];
        [getAvgDelay(K, Mk, p) cost( K, p, Mk, alpha )];
        count = count + 1;
    end

    results = results(results(:,1)>0,:);
end

