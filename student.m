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
       function B = regress(X,Y,df) 
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
       end
   end
end
