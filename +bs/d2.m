function d2 = d2(S, K, t, vol, r, T, q)

    if nargin == 6, q = 0; end
    d2 = bs.d1(S,K,t,vol,r,T,q) - vol*sqrt(T-t);
end