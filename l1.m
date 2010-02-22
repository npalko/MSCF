classdef l1 < handle
    methods (Static)
        function stats = regstats(y, X)
            % L-1 multiple linear regression
            % original version: Will Dwinnell, Mar-27-2009 
           
            [n m] = size(X); 
            B = [ones(n,1) X] \ y;  % Least squares regression 
            BOld = B; % Initialize with least-squares fit 

            % Force divergence 
            BOld(1) = BOld(1) + 1e-5;

            % Repeat until convergence 
            while (max(abs(B - BOld)) > 1e-6) 
               % Move old coefficients 
               BOld = B; 
               % Calculate new observation weights (based on residuals from old 
               % coefficients) 
               W = sqrt(1 ./ max(abs((BOld(1) + (X * BOld(2:end))) - y),1e-6)); 
               % Floor to avoid division by zero 
               % Calculate new coefficients 
               B = (repmat(W,[1 m+1]) .* [ones(n,1) X]) \ (W .* y); 
            end
            
            stats.beta = B;
            stats.r = y - [ones(n,1) X] * stats.beta;   % residuals
            stats.m = size(X,2) + 1; % numer of covariates (includes intercept!)
            stats.sigmaHat = sum(abs(stats.r))/numel(stats.r);
        end
        function ci = confidenceIntervals(stats, X, alpha, n)
            
            if nargin == 2
                alpha = .05;
                n = 100;
            elseif nargin == 3
                n = 100;
            end
            
            X1 = [ones(size(stats.r)) X];
            [l,m] = size(X1);
            
            bSim = zeros(m, n);
            for i=1:n
                ytSim = X1*stats.beta + randlaplace(size(stats.r), 1/stats.sigmaHat);
                tmpStats = l1.regstats(ytSim, X);
                bSim(:,i) = tmpStats.beta;
            end
            simtCov = cov(bSim');
            ses = sqrt(diag(simtCov));
            llbCI = stats.beta - ses * norminv(1-alpha,0,1);
            rlbCI = stats.beta + ses * norminv(1-alpha,0,1);
            
            ci = [llbCI rlbCI];
        end
        function aic = AIC(stats)
            n = numel(stats.r);  % number of observations     
            aic = 2*n * (log(2*stats.sigmaHat) + 1) + 2*stats.m;
        end
        function bic = BIC(stats)
            n = numel(stats.r); % number of observations     
            bic = 2*n * (log(2*stats.sigmaHat) + 1) + stats.m*log(n);
       end
   end
end
