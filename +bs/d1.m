function d1 = d1(S, K, t, vol, r, T, q)

    if nargin == 6, q = 0; end
    F = bs.F(S, t, r, T, q);

    d1 = (log(F/K) + ((vol^2)/2)*(T-t)) / (vol * sqrt(T-t));
end