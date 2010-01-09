function [alpha beta] = alpha(market, security, userOption)
%{
Regress the security returns against the market returns, obtaining an
alpha and beta time series using an options.days day window. market, 
security, alpha, and beta are all single column vectors. 

The returns from t=[1,n] define alpha, beta on day n+1. (that is, no 
looking into the future ...). In order to keep the size of the input and
output consistent, we only return alpha, beta up to day n.

Insufficient data: if there are less than options.days data points, 
options.unknownAlpha and options.unknownBeta are returns for alpha and 
beta.
%}

    option = struct( ...
        'unknownAlpha', NaN, ...
        'unknownBeta', 1, ...
        'days', 260 ...
    );

    % use user-supplied options if specified

    userOptionSpecified = (nargin == 3);
    if userOptionSpecified
        field = fieldnames(userOption);
        for i=1:numel(field)
            option.(field{i}) = userOption.(field{i});
        end
    end

    
    % market and security must be column vectors of the same size
    
    assert(size(market,2) == 1, ...
        'market returns must be a column vector');
    assert(size(security,2) == 1, ...
        'security returns must be a column vector');
    assert(size(market,1) == size(security,1), ...
        'market and security vectors must be the same size');
    nObservation = size(market,1);
    
    
    % preallocate result with default values
    
    alpha = repmat(option.unknownAlpha, nObservation, 1);
    beta = repmat(option.unknownBeta, nObservation, 1);
    
    
    %
    
    window = option.days;
    for i=(window+1):nObservation

        windowIndex = (i-window):i;
        
        [coefficent ignore residual] = regress(market(windowIndex), ...
            security(windowIndex));
        
        alpha(i) = residual;
        beta(i) = coefficent;
    end


end