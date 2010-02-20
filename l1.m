classdef l1 < handle
   methods (Static)
       % L1LinearRegression: Calculates L-1 multiple linear regression by IRLS
       %
       % by Will Dwinnell
       % 
       % B = L1LinearRegression(X,Y) 
       % 
       % B = discovered linear coefficients 
       % X = independent variables 
       % Y = dependent variable 
       % 
       % Note 1: An intercept term is assumed (do not append a unit column). 
       % Note 2: a.k.a. LAD, LAE, LAR, LAV, least absolute, etc. regression 
       % 
       % Last modified: Mar-27-2009 
       % 

       function B = regress(X,Y) 
           % Determine size of predictor data
           [n m] = size(X); 
           % Initialize with least-squares fit 
           B = [ones(n,1) X] \ Y; 
           % Least squares regression 
           BOld = B; 

           % Force divergence 
           BOld(1) = BOld(1) + 1e-5;

           % Repeat until convergence 
           while (max(abs(B - BOld)) > 1e-6) 
               % Move old coefficients 
               BOld = B; 
               % Calculate new observation weights (based on residuals from old coefficients) 
               W = sqrt(1 ./ max(abs((BOld(1) + (X * BOld(2:end))) - Y),1e-6)); 
               % Floor to avoid division by zero 
               % Calculate new coefficients 
               B = (repmat(W,[1 m+1]) .* [ones(n,1) X]) \ (W .* Y); 
           end
       end
   end
end
