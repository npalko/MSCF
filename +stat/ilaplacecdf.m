function Finv = ilaplacecdf(p, mu, b)

    Finv = mu - b * sign(p-.5) * log(1-2*abs(p-.5));
    
end

