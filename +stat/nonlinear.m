classdef nonlinear < handle
   methods (Static)     
       function stats = regstats(X,y,f)
           
           beta0 = X\ y;
           options = statset('TolX', 1e-15, 'TolFun', 1e-15, ... 
                              'MaxIter', 10000, 'Display', 'off');
                          
           [beta,r,J,COVB,mse] = nlinfit(X,y,fun,beta0, options);
           
           stats.beta = beta;
           stats.r = r;
           stats.covariance = covb;
           stats.jacobian = J;
       end
       
       function ci = confidenceIntervals(stats, alpha)
           if nargin == 1
               alpha = 0.05;
           end
           
           ci = nlparci(stats.beta, stats.r, 'covar', stats.covariance, ...
                            'alpha', alpha);
       end
   end
end

