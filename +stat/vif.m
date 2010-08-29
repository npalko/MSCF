function vifs = vif(X)
    [n, m] = size(X);
    
    vifs = zeros(m,1);
    indices = 1:m;
    
    for i=1:m
        indices(i) = 0;
        
        stats = regstats(X(:,i), X(:,nonzeros(indices)));
        vifs(i) = 1 / (1 - stats.rsquare);
        
        indices(i) = i;
    end
end