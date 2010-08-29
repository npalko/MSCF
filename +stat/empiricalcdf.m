function F = empiricalcdf(x, s)
    F = nnz(s <= x)/numel(s);
end