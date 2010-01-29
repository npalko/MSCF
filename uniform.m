% Generate values from the uniform distribution on the interval [A, B] of
% dimension DIM.

function r = uniform(a, b, dim)

    r = a + (b - a) .* rand(dim);

end