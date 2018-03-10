%delay aware algorithm 
%INPUTS: CB, DLstar, GAMMA, K, bit, step, 

K1 = size(V,1);
chi1 = ones(K1,1) * DLstar;
gammak = abs(GAMMA(:,1));
lk = ones(K1,1);
dl = gamma(2,:);
Cb = CB - sum(chi1);

while Cb > 0
    [MAX, k] = max(gammak);

    if Cb >= dl(lk(k) + 1) - dl(lk(k))
        Cb = Cb - (dl(lk(k) + 1) - dl(lk(k)));
        chi1(k) = dl(lk(k) + 1);
        lk(k) = lk(k) + 1;
        gammak(k) = abs(GAMMA(k,lk(k)));
    else 
        chi1(k) = chi1(k) + Cb;
        Cb = 0;
    end
end
