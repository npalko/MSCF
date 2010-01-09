function d2 = d2(S, K, t, vol, r, T)

    d2 = bs.d1(S,K,t,vol,r,T) - vol*sqrt(T-t);
end