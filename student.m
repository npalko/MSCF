classdef student < handle
   methods (Static)
       
       % Find the sigma that maximizes the Log Liklihood function given a B
       function s = findLonS(r,df)
           n = length(r);
           
           % if x ~ t location, scale distribution with df 
           % degrees of freedom, then (x-u)/sigma ~ t(df)
           f = @(s) -sum(log(tpdf(r ./ s, df)));
           
           s = fminunc(f, (r'*r)/n);
       end

       function B = regress(X,Y,df) 
           [n,m] = size(X);

           bInit = ones(m, 1);
           
           r = (Y - X*bInit);
           s = student.findLonS(r, df);

           % if x ~ t location, scale distribution with df 
           % degrees of freedom, then (x-u)/sigma ~ t(df)
           f = @(b) -sum(log(tpdf((Y - X*b) ./ s, df)));
           
           options = optimset('MaxFunEvals', 10000, 'TolX', 1e-16, 'TolFun', 1e-16);
           [B, fval] = fminunc(f, bInit, options); 
       end
   end
end
