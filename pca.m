classdef pca < handle
    methods (Static)
        function stats = regstats(y, X)
            [n, m] = size(X);
            means = mean(X, 1);
            stdevs = sqrt(var(X, 1));
            
            centeredX = X - repmat(means, n, 1);
            normalizedX = centeredX ./ repmat(stdevs, n, 1);

            [U,S,V] = svd(normalizedX, 'econ');
            
            principalvalues = diag(S*S);
            principalcomponents = normalizedX * V;
            
            proportions = principalvalues ./ sum(principalvalues);
            
            neededcomponents = [];
            total = 0;
            i = 1;
            while total < 0.95
                neededcomponents = [principalcomponents(:, i) neededcomponents];
                total = total + proportions(i);
                i = i + 1;
            end
            
            stats = regstats(y, neededcomponents);
            stats.design = neededcomponents;
            stats.principalvalues = principalvalues(1:i-1);
            stats.proportions = proportions(1:i-1);
        end
    end
end
