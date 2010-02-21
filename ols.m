classdef ols < handle
   methods (Static) % pretty printing
       function printBasicSummary(stats)
           % print R^2, F, p-val
           
           % R^2:   percent of variance in the values in Y which can be
           %        explained by knowing the value of X.
           % F:     ratio of explained variance to unexplained variance. 
           %        usually F > 4 is statistically significant
           % p-val: null hypothesis that explaintory variables are jointly
           %        of no use explaining obvservations
           
           fprintf('R^{2} = %10.6f\r', stats.rsquare);
           fprintf('F     = %10.6f\r', stats.fstat.f);
           fprintf('p-val = %10.6f\r', stats.fstat.pval);
       end
       function printExplanitorySummary(stats, fields)
           
           % t:     test of whether the slope of a regression line differs
           %        significantly from 0
           % p-val: if it is below the statistical significant level (eg.
           %        0.05, 0.01), then the null hypothesis is rejected in
           %        favor of the alternate hypothesis
           
           t = stats.tstat;
           fields = [{'(Intercept)'} fields]';
           
           if nargout == 0
               fprintf('%14s %10s %10s %10s %10s\r', ...
                   '','Value','Std Error','t value', 'p-value');
               for i=1:numel(fields)
                   fprintf('%14s %10.4f %10.4f %10.4f %10.4f\r', ...
                       fields{i}, t.beta(i), t.se(i), t.t(i), t.pval(i));
               end
           end  
       end
       function printci(fields, beta, ci)
           % print confidence interval
           
           for i=1:numel(fields)
               fprintf('%14s = %10.4f, [%10.4f,%10.4f]\r', ...
                   fields{i}, beta(i), ci(i,1), ci(i,2));
           end
       end
   end
   methods (Static)
       % takes regstats stats output
       function aic = AIC(X, y, stats, weights)
           m = size(X, 2)+1;  % number of covariates
           n = size(y, 1);  % number of observations
           
           if(nargin == 3)
               weights = ones(n,1);
           end
           
           r = y - [ones(n,1) X] * stats.beta;
           RSS = r' * (r .* weights);    % RSS
           
           aic = n * (log(2*pi) + 1) + n*log(RSS/n) + 2*m - sum(log(weights));
       end
       
       % takes regstats stats output
       function bic = BIC(X, y, stats, weights)
           m = size(X, 2)+1;  % number of covariates
           n = size(y, 1);  % number of observations
           
           if(nargin == 3)
               weights = ones(n,1);
           end
           
           r = y - [ones(n,1) X] * stats.beta;
           RSS = r' * (r .* weights);    % RSS
           
           bic = n * (log(2*pi) + 1) + n*log(RSS/n) + log(n)*m - sum(log(weights));
       end
   end
   methods (Static) % confidence intervals
       function ci = independentci(stats, alpha)
           % return the independent CI for beta (this is provided by the
           % regress() function, but not readily available 
           
           if nargin == 1
               alpha = 0.05;
           end
           
           beta = stats.beta;
           se = stats.tstat.se;
           dfe = stats.tstat.dfe;
           
           tval = tinv((1-alpha/2), dfe);
           d = tval*se;
           
           ci = [beta-d beta+d];
       end
       function ci = simultci(X, stats, alpha, p)
           % use wald statistic
           % scheffe method
           % pg 41 notes

           % p: number of coefficients in the model, including the 
           % intercept. If we preform a 4 \beta regression, but require
           % only 2 simultaneous measurements, we would set p=2 here.
           
           
           if nargin == 2
               % defaults
               
               alpha = 0.05;
               p = stats.fstat.dfr + 1;
           end
           
           n = size(X,1);       % n: total number of x data points
           X = [ones(n,1) X];   % X does not include ones by default
           betaHat = stats.beta;
           RSS = stats.fstat.sse;
           
           sigmaHat = sqrt(RSS/(n-p));  
           se = sigmaHat * diag(sqrt((X'*X)^-1));
           multiplier = sqrt(p*icdf('F', 1-alpha, p, n-p));
           d = multiplier .* se;
           
           ci = [betaHat-d betaHat+d];
       end 
   end
   methods (Static) % diagnostics
       function ms = modelSelection(reducedModelStats, fullModelStats)
           % model1: reduced model
           % model2: full model
           
           RSS1 = reducedModelStats.fstat.sse;
           RSS2 = fullModelStats.fstat.sse;
           df1 = reducedModelStats.fstat.dfe;
           df2 = fullModelStats.fstat.dfe;
           
           ms.fstat = ((RSS1-RSS2)/(df1-df2)) * (df2/RSS2);
           ms.pvalue = 1 - fcdf(ms.fstat, df1-df2, df2);
       end
       function diagnose()

           % Durbin-Watson statistic
           % Check for the violation of any of the following assumptions
           %  1. linearity
           %  2. homoscedasticity
           %  3. non-normality
           %  4. independence of errors

       end 
   end
end