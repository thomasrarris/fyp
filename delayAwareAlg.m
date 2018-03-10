%delay aware algorithm 
%INPUTS: CB, DLstar, GAMMA, K, bit, step, 

Dk = ones(K,1) * DLstar;
gammak = abs(GAMMA(:,1));
lk = ones(K,1);
dl = gamma(2,:);
Cb = CB;

while Cb > 0
    [MAX, k] = max(gammak);

    if Cb >= dl(lk(k) + 1) - dl(lk(k))
        Cb = Cb - (dl(lk(k) + 1) - dl(lk(k)));
        Dk(k) = dl(lk(k) + 1);
        lk(k) = lk(k) + 1;
        gammak(k) = abs(GAMMA(k,lk(k)));
    else 
        Dk(k) = Dk(k) + Cb;
        Cb = 0;
    end
end
