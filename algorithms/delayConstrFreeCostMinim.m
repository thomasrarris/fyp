function Mk = delayConstrFreeCostMinim( V, CB, D_max, alpha )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    K = size(V,1);
    Mk = zeros(K,1);
    
    gradient1 = - alpha;
    gradient2 = (alpha - 1)/(D_max - 1);
    
    GAMMA = V * [gradient1 gradient2 0];    
    gammak = abs(GAMMA(:,1));   
    
    dl = [0 1 D_max]/D_max;
    ml = ones(K,1);
    Cb = CB - sum(Mk);

    while Cb > 0
        [~, k] = max(gammak);

        if Cb >= dl(ml(k) + 1) - dl(ml(k))
            Cb = Cb - (dl(ml(k) + 1) - dl(ml(k)));
            Mk(k) = dl(ml(k) + 1);
            ml(k) = ml(k) + 1;
            gammak(k) = abs(GAMMA(k,ml(k)));
        else 
            
            k = size(Mk(Mk ~= 0),1) + 1;
            while Cb > 1/D_max - 10^-10
                if k <= K
                    Cb = Cb - (dl(ml(k) + 1) - dl(ml(k)));
                    Mk(k) = dl(ml(k) + 1);
                    ml(k) = ml(k) + 1;
                    gammak(k) = abs(GAMMA(k,ml(k)));
                    k = k + 1;
                else
                    Cb = 0;
                end
            end
            Cb = 0;
        end
    end
end

