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
       
       function l = LLH(X,Y,B,s,df)
           r = Y - X*B;
           adjusted_residuals = r ./ s;
           
           a = (df+1)/2;
           numer = gamma(a);
           denom = sqrt(df*pi)*gamma(df/2);
           llh_1 = n*log(numer/denom);
           llh_2 = -a * sum(log(1 + adjusted_residuals));
       
           l = llh_1 + llh_2;
       end
           
       % Find the sigma that maximizes the Log Liklihood function given a B
       function [l, g] = solveLLH(X,Y,B,df)
           
           beta = B(1:end-1);
           sigma = abs(B(end));
           
           l = student.LLH(X, Y, beta, sigma, df);
           g = -student.gradient(X, Y, beta, sigma, df);
       end

       % X should contain the intercept vector of 1s
       function [beta, sigma] = regress(X,Y,df) 
           X1 = [ones(length(Y)) X];
           [n,m] = size(X1);
           
           bInit = X1\ Y;
           r = Y - X1*bInit;
           
           bInit = [bInit; sqrt(mean(r .^ 2))];

           fHandle = @(b) student.solveLLH(X1,Y,b,df);
           
           options = optimset('MaxFunEvals', 10000, 'TolX', 1e-15, ...
                              'TolFun', 1e-15, 'GradObj', 'on', ...
                              'MaxIter', 10000, 'Display', 'on');
                           
           [B, fval] = fminunc(fHandle, bInit, options); 
           beta = B(1:end-1);
           sigma = abs(B(end));
       end
   end
   methods (Static)
       % takes regstats stats output
       function aic = AIC(X, y, beta, sigma, df)
           [n,m] = size(X);
           
           l = student.LLH(X,Y,B,sigma,df);
           aic = -2*l + 2*(m+2);
       end
       
       % takes regstats stats output
       function bic = BIC(X, y, beta, sigma, df)
           [n,m] = size(X);
           
           l = student.LLH(X,Y,B,sigma,df);
           bic = -2*l + (m+2)*log(n);
       end
   end
end
