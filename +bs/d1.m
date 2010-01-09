function d1 = d1(S, K, t, vol, r, T)

    d1 = (log(S/K) + (r + (vol^2)/2)*(T-t)) / (vol * sqrt(T-t));
end