classdef student < handle
   methods (Static)     
       % Solve for the gradient vector
       function gr = gradient(X,Y,B,sigma,df)
          [n,m] = size(X);
          r = Y - X*B;
          
          z = X;
          
          w = r ./ (sigma^2 * df + r'*r);
          for i=1:m
            z(:,i) = z(:,i) .* w;
          end
          
          sder = (-n + (df+1)*sum(r .* w)) / sigma;
          
          gr = [(df+1)*sum(z,1) sder];
       end
       
       function l = LLH(r,s,df)
           n = length(r);

           adjusted_residuals = ((r ./ s) .^ 2) ./ df;
           
           a = (df+1)/2;
           numer = gamma(a);
           denom = s*sqrt(df*pi)*gamma(df/2);
       
           l = n*log(numer/denom) - a*sum(log(1 + adjusted_residuals));
       end
           
       % Find the sigma that maximizes the Log Liklihood function given a B
       function [l, g] = solveLLH(X,Y,B,df)
           
           beta = B(1:end-1);
           sigma = abs(B(end));
           
           r = Y - X*beta;
           
           l = -student.LLH(r, sigma, df);
           g = -student.gradient(X, Y, beta, sigma, df);
       end

       % X should contain the intercept vector of 1s
       function stats = regstats(y, X, df) 
           X1 = [ones(length(y),1) X];
           [n,m] = size(X1);
           
           bInit = X1\ y;
           r = y - X1*bInit;
           
           bInit = [bInit; sqrt(mean(r .^ 2))];

           fHandle = @(b) student.solveLLH(X1,y,b,df);
           
           options = optimset('MaxFunEvals', 10000, 'TolX', 1e-15, ...
                              'TolFun', 1e-15, 'GradObj', 'on', ...
                              'MaxIter', 10000, 'Display', 'off');
                           
           [B, fval] = fminunc(fHandle, bInit, options); 
           
           stats.beta = B(1:end-1);
           stats.r = y - X1*stats.beta;
           stats.sigmaHat = abs(B(end));
           stats.m = m;
           stats.df = df;
       end
       
       function ci = confidenceIntervals(stats, X, alpha, n)
           if nargin == 2 
               alpha = .05;
               n = 100;
           elseif nargin == 3 
               n = 100;
           end
           
           m = length(stats.beta);
           X1 = [ones(size(X,1),1) X];
       
           bSim = zeros(m, n);
           
           yBase = X1*stats.beta;
           
           for i=1:n
               ytSim = yBase + stats.sigmaHat * ...
                                      trnd(stats.df, [length(stats.r) 1]);
               simStats = student.regstats(ytSim, X, stats.df);
        
               bSim(:,i) = simStats.beta;
           end
           
           simtCov = cov(bSim');
           ses = sqrt(diag(simtCov));
           
           ltbCI = stats.beta - ses * norminv(1-alpha,0,1);
           rtbCI = stats.beta + ses * norminv(1-alpha,0,1);
           
           ci = [ltbCI rtbCI];
       end
       
       % takes regstats stats output
       function aic = AIC(stats)
           
           llh = student.LLH(stats.r,stats.sigmaHat,stats.df);
           aic = -2*llh + 2*(stats.m+1);
       end
       
       % takes regstats stats output
       function bic = BIC(stats)
           n = length(stats.r);
           
           llh = student.LLH(stats.r,stats.sigmaHat,stats.df);
           bic = -2*llh + (stats.m+1)*log(n);
       end
   end
end
