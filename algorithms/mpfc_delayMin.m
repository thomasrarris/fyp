function Mk = mpfc_delayMin( C, T_max, K)

    Mk = ones(K,1) * 1 / T_max;
    CB = C - sum(Mk);

    counter = 1;
    while CB > 0

        if CB >= 1 - 1/T_max
            Mk(counter) = 1;
            CB = CB - (1 - 1/T_max);
            counter = counter + 1;
        else 
            Mk(counter) = Mk(counter) + CB;
            CB = 0;
        end

    end
end

