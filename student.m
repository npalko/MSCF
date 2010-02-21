classdef student < handle
   methods (Static)
               
       % Solve for the gradient vector
       function gr = gradient(X,Y,B,df)
          [n,m] = size(X);
          r = Y - X*B(1:end-1);
          
          z = X;
          
          w = r ./ (B(end)^2 * df + r'*r);
          for i=1:m
            z(:,i) = z(:,i) .* w;
          end
          
          sder = (-n + (df+1)*sum(r .* w)) / abs(B(end));
          
          gr = [(df+1)*sum(z,1) sder];
       end
       
       % Find the sigma that maximizes the Log Liklihood function given a B
       function [s, g] = LLH(X,Y,B,df)
           r = Y - X*B(1:end-1);
           
           s = -sum(log(tpdf(r ./ B(end), df)));
           g = -student.gradient(X,Y,B,df);
       end

       % X should contain the intercept vector of 1s
       function [B, s] = regress(X,Y,df) 
           [n,m] = size(X);
           
           bInit = X\ Y;
           r = Y - X*bInit;
           
           bInit = [bInit; sqrt(mean(r .^ 2))];

           fHandle = @(b) student.LLH(X,Y,b,df);
           
           options = optimset('MaxFunEvals', 10000, 'TolX', 1e-16, ...
                              'TolFun', 1e-16, 'GradObj', 'on', ...
                               'MaxIter', 10000);
                           
           [B, fval] = fminunc(fHandle, bInit, options); 
           B = B(1:end-1);
           s = B(end);
       end
   end
   methods (Static)
       % takes regstats stats output
       function aic = AIC(X, y, beta, sigma, df)
           [n,m] = size(X);
           r = y - [ones(n,1) X]*beta;
           
           
           llh_1 = n*(gamma((df+1)/2)/(sigma*sqrt(df*pi)*gamma(df/2)));
           llh_2 = -((df+1)/2)*sum(log(1 + ((r ./ sigma) .^ 2) ./ df));
           
           aic = -2*(llh_1 + llh_2) + 2*(m+1);
       end
       
       % takes regstats stats output
       function bic = BIC(X, y, beta, sigma, df)
           [n,m] = size(X);
           r = y - [ones(n,1) X]*beta;
           
           
           llh_1 = n*(gamma((df+1)/2)/(sigma*sqrt(df*pi)*gamma(df/2)));
           llh_2 = -((df+1)/2)*sum(log(1 + ((r ./ sigma) .^ 2) ./ df));
           
           bic = -2*(llh_1 + llh_2) + (m+1)*log(n);
       end
   end
end
