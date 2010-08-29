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
       function aic = AIC(stats, weights)
           m = length(stats.beta);  % number of covariates
           n = length(stats.r);  % number of observations
           
           if(nargin == 1)
               weights = ones(n,1);
           end
           
           RSS = stats.r' * (stats.r .* weights);    % RSS
           
           aic = n * (log(2*pi) + 1) + n*log(RSS/n) + 2*(m+1) - sum(log(weights));
       end
       
       % takes regstats stats output
       function bic = BIC(stats, weights)
           m = length(stats.beta);  % number of covariates
           n = length(stats.r);  % number of observations
           
           if(nargin == 1)
               weights = ones(n,1);
           end
           
           RSS = stats.r' * (stats.r .* weights);    % RSS
           
           bic = n * (log(2*pi) + 1) + n*log(RSS/n) + log(n)*(m+1) - sum(log(weights));
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
       function plotConfidenceIntervals(y, X, alpha, filename)
           % Draw scatter, regression line, and upper/lower bands
           % With thanks to Nicholas Palko for help on the following lines to get the 
           % appropriate bands for the Wald test in matlab
           
           [n,m] = size(X);
           if m ~= 1
               error('To plot confidence intervals, X must be a nx1 vector');
           end
           
           if nargin == 2
                alpha = 0.05;
                filename = 'Confidence Bands';
           elseif nargin == 3
                filename = 'Confidence Bands';
           end
           
           stats = regstats(y, X);
           
           xbar = mean(X);
           st = sqrt(sum(stats.r .^ 2) / (n-2));
           Sxx = sum((X - xbar) .^ 2);
           F = icdf('F', 1-alpha, 2, n-2);
           se = @(xi) st * sqrt(1/n + ((xi-xbar)^2)/Sxx);
           
           band_f = @(xi) stats.beta(1) + stats.beta(2)*xi + [1 -1] * se(xi)*sqrt(2*F);

           xLim = [min(X) max(X)];
           [xRegress yRegress] = fplot(@(x) stats.beta(1) + stats.beta(2) * x, xLim);

           f = figure();
           line(X,y,'Parent',gca(),'Marker','.','Line','None');
           line(xRegress, yRegress, 'Parent', gca(), 'Color', 'red');

           [xBand, yBand] = fplot(band_f, xLim);
           line(xBand, yBand, 'Parent', gca(), 'Color', 'green');

           title('Confidence Bands for Regression Line');
           
           saveas(f, filename, 'pdf');
       end
   end
   methods (Static) % diagnostics
       function w = waldTest(stats, C, c)
           % The Wald test statistic 
           diff = C * stats.beta - c; 
           Vdiff = C * stats.covb * C; 
           W = diff' * (Vdiff \ diff);

           % The rejection region 
           df = size(C,1);
           pval = fpdf(W/2, df, n-2);
           
           w.waldstat = W;
           w.pvalue = pval;
       end
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
       function dw = diagnoseResiduals(stats, X, filename)
           [n,m] = size(X);
           residuals = stats.r;
           y_estimate = [ones(n,1) X]*stats.beta;

           [c_ww,lags] = xcorr(residuals,'coeff');

           % Check residuals
           f = figure();  
           
           total_plots = 6+m;
           ns = ceil(sqrt(total_plots)); %nearest square
                      
           subplot(ns,ns,1), hist(residuals);          %check normality
           title('Histogram (normality)');
           subplot(ns,ns,2), qqplot(residuals);        %check normality
           title('QQ-Plot (normality)');
           subplot(ns,ns,3), boxplot(residuals);       %check normality
           title('Box-Plot');
           subplot(ns,ns,4), line(y_estimate, residuals, 'Marker', '.', 'Line', 'None');  %check non-linearity 
           title('Residuals vs y-hat (non-linearity)');
           subplot(ns,ns,5), plot(residuals);                    %check homoscedasticity
           title('Homoscedasticity Check');
           subplot(ns,ns,6), stem(lags, c_ww);            %check independence
           title('Autocorrelation (independence)');

           for i = 1:m
               subplot(ns,ns,6+i), line(residuals, X(:,i), 'Marker', '.', 'Line', 'None');             %check non-linearity 
               switch mod(i,10)
                   case 1
                        t = sprintf('Residuals vs %dst covariate (non-linearity)', i);
                   case 2
                        t = sprintf('Residuals vs %dnd covariate (non-linearity)', i);
                   case 3
                        t = sprintf('Residuals vs %drd covariate (non-linearity)', i);
                   otherwise
                        t = sprintf('Residuals vs %dth covariate (non-linearity)', i);
               end
               
               % check special cases 11, 12, 13
               if i == 11 || i == 12 || i == 13
                   t = sprintf('Residuals vs %dth covariate (non-linearity)', i);
               end
               title(t);
           end

           saveas(f, filename, 'pdf');
           
           [p,ds] = dwtest(residuals, [ones(n,1) X]);
           
           dw.pvalue = p;
           dw.dwstate = ds;
       end 
   end
end