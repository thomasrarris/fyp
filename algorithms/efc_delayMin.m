function Mk = efc_delayMin( C, T_max, gamma, K )

    l = 1;
    DL = gamma(2,:);
    Mk = ones(K,1) * 1 / T_max;
    CB = C - sum(Mk);


    while CB > 0

        if CB >= K * (DL(l+1)-DL(l)) 
            Mk(:,1) = Mk(:,1) + (DL(l+1)-DL(l));
            CB = CB - K * (DL(l+1)-DL(l));
            l = l + 1;
        else
            counter = 1;
            while CB > 0
                if CB >= DL(l+1)-DL(l)
                    Mk(counter,1) = Mk(counter,1) + (DL(l+1)-DL(l)) ;
                    counter = counter + 1;
                    CB = CB - (DL(l+1)-DL(l));
                    
                else
                    Mk(counter,1) = Mk(counter,1) + CB;
                    CB = 0;
                end
            end
        end
    end

end

