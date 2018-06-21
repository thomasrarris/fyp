function  Mk = delayAwareAlgorithm( V, mlmin, GAMMA, gamma, CB )
    % implementation of the cost-free delay minimisation algorithm
    % INPUTs
    % V:      video robability distribution (in asc. order)
    % mlmin:  minimum required size of cached data
    % GAMMA:  matrix K by mlmax with all gradients of all files
    % gamma:  vector 2 bt mlmax with delay levels and decrement points
    % CB:     bit-size normalised cache size
    %
    % OUTPUTS:  
    % Mk:     Optimal caching policy

    K = size(V,1);
    Mk = ones(K,1) * mlmin;
    CB = CB - sum(Mk);

    gammak = abs(GAMMA(:,1));  % next gradient value of each file
    l = ones(K,1);             % delay level of each file
    m = gamma(2,:);            % set of decrement points

    while CB > 0
        [~, k] = max(gammak);

        if CB >= m(l(k) + 1) - m(l(k))
            CB = CB - (m(l(k) + 1) - m(l(k)));
            Mk(k) = m(l(k) + 1);
            l(k) = l(k) + 1;
            gammak(k) = abs(GAMMA(k,l(k)));
        else 
            Mk(k) = Mk(k) + CB;
            CB = 0;
        end
    end
end

