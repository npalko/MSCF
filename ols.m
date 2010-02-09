classdef ols < handle
   methods (Static)
       function printBasicSummary(stats)
           
           % R^2:   precent of variance in the values in Y which can be
           %        explained by knowing the value of X.
           % F:     ratio of explained variance to unexplained variance. 
           %        usually F > 4 is statistically significant
           % p-val: null hypothesis that explaintory variables are jointly
           %        of no use explaining obvservations
           
           fprintf('R^2 = %f, F = %f, p-val = %f\r', ...
               stats.rsquare, stats.fstat.f, stats.fstat.pval);
       end
       function s = explanitorySummmary(stats, fields)
           
           % t:     test of whether the slope of a regression line differs
           %        significantly from 0
           % p-val: if it is below the statistical significant level (eg.
           %        0.05, 0.01), then the null hypothesis is rejected in
           %        favor of the alternate hypothesis
           
           t = stats.tstat;
           fields = [{'(Intercept)'} fields]';
           
           s = [ {[],'Value', 'Std Error', 't value', 'p-val'}
                 [fields num2cell([t.beta t.se t.t t.pval])] 
               ];
       end
       function simultci(X, stats)
           
           alpha = .05; 
           p = stats.fstat.dfr + 1;     % p: number of coefficients in the 
                                        %    model, including the 
                                        %    intercept
           n = stats.fstat.dfe + p;     % n: total number of x data points
           
           RSS = stats.fstat.see;
           sigma = sqrt(RSS/(n-p));
           
           se = sigma * sqrt((X'*X)^-1);
           % get diagonals
           
           % use wald statistic
           % scheffe method
           % pg 41 notes
           multiplier = sqrt(p*icdf('F', 1-alpha, p, n-p));
           
           
           
           
       end
       function anova()
           
           fprintf('\r')
           fprintf('Regression ANOVA');
           fprintf('\r\r')

           fprintf('%6s','Source');
           fprintf('%10s','df','SS','MS','F','P');
           fprintf('\r')

           fprintf('%6s','Regr');
           fprintf('%10.4f', f.dfr, f.ssr, f.ssr/f.dfr, f.f, f.pval);
           fprintf('\r')

           fprintf('%6s','Resid');
           fprintf('%10.4f',f.dfe ,f.sse, f.sse/f.dfe);
           fprintf('\r')
           fprintf('%6s','Total');
           fprintf('%10.4f', f.dfe+f.dfr, f.sse+f.ssr);
           fprintf('\r')
    
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