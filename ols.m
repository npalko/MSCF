classdef ols < handle
   methods (Static)
       function printBasicSummary(stats)
           % print R^2, F, p-val
           
           % R^2:   percent of variance in the values in Y which can be
           %        explained by knowing the value of X.
           % F:     ratio of explained variance to unexplained variance. 
           %        usually F > 4 is statistically significant
           % p-val: null hypothesis that explaintory variables are jointly
           %        of no use explaining obvservations
           
           fprintf('R^2 = %f\rF = %f\rp-val = %f\r', ...
               stats.rsquare, stats.fstat.f, stats.fstat.pval);
       end
       function ci = independentci(stats)
           % return the independent CI for beta (this is provided by the
           % regress() function, but not readily available 
           
           alpha = 0.05;
           
           beta = stats.beta;
           se = stats.tstat.se;
           dfe = stats.tstat.dfe;
           
           tval = tinv((1-alpha/2), dfe);
           ci = [beta-tval*se beta+tval*se];
       end
       function ci = simultci(X, stats)
           % use wald statistic
           % scheffe method
           % pg 41 notes
           
           alpha = .05; 
           p = stats.fstat.dfr + 1;     % p: number of coefficients in the 
                                        %    model, including the 
                                        %    intercept
           n = stats.fstat.dfe + p;     % n: total number of x data points
           beta = stats.beta;
           
           RSS = stats.fstat.sse;
           sigmaHat = sqrt(RSS/(n-p));  
           X = [ones(size(X,1),1) X]; % X does not include ones by default
           se = sigmaHat * diag(sqrt((X'*X)^-1));
   
           multiplier = sqrt(p*icdf('F', 1-alpha, p, n-p));
           d = multiplier .* se;
           
           ci = [beta-d beta+d];
       end 
       function printci(fields, beta, ci)
           % print confidence interval
           
           for i=1:numel(fields)
               fprintf('%s = %f, [%f,%f]\r', ...
                   fields{i}, beta(i), ci(i,1), ci(i,2));
           end
       end
       function s = explanitorySummmary(stats, fields)
           % return cell array of factor summary
           
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
           
           
           if nargout == 0
               fprintf('%14s %10s %10s %10s %10s\r', ...
                   '','Value','Std Error','t value', 'p-value');
               for i=1:numel(fields)
                   fprintf('%14s %10.4f %10.4f %10.4f %10.4f\r', ...
                       fields{i}, t.beta(i), t.se(i), t.t(i), t.pval(i));
               end
           end  
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