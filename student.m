classdef student < handle
   methods (Static)
       
       % Find the sigma that maximizes the Log Liklihood function given a B
       function s = findLonS(r,df)
           n = length(r);
           
           % if x ~ t location, scale distribution with df 
           % degrees of freedom, then (x-u)/sigma ~ t(df)
           m = @(s) 1 / sum(log(tpdf(r ./ s, df)));
           
           s = fminunc(m, (r'*r)/n);
       end

       function B = regress(X,Y,df) 
           [n,m] = size(X);
           xWithConst = [ones(n,1) X];

           bInit = xWithConst\ Y;
           
           r = (Y - xWithConst*bInit);
           s = student.findLonS(r, df);
           
           f = @(b) 1 / sum(log(tpdf((Y - xWithConst*b) ./ s, df)));

           B = fminunc(f, bInit); 
       end
   end
end
