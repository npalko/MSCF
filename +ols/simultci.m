function ci = simultci(X, r, b, alpha)
    % return the simultaneous confidence intervals given:
    %
    %   X: matrix of explanitory variables; the first column must be ones
    %   r: vector of residuals from regression
    %   b: regression coefficient for each explanitory variable
    
    if nargin == 3
        alpha = 0.05;
    end
    
    % pg 35 of typed notes
    
    k = size(X,2);          % k is the number of parameters, including the 
                            % vector of 1's in X, corresponding to the 
                            % intercept parameter (\beta_{0})
                        
    p = k + 1;              % there are p-1 degress of freedom for 
                            % regression corresponding to the k = p - 1 
                            % parameters \beta_{1} ... \beta_{k}
  
    n = numel(r);                 
    RSS = sum(r.^2);
    s = sqrt(RSS/(n-p)); % unbiased estimator of sigma
    F = icdf('F', 1-alpha, p, n-p); % multiplier (pg 41)
    
    m = F*s*sqrt(b'*((X'*X)^-1)*b);
    
    ci = [b+m b-m];

    
    


end