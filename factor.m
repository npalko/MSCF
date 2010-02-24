classdef factor < handle
   methods (Static) % pretty printing
       function stats = fitfactors(X, k, rotation)
           [n, m] = size(X);
           
           if nargin == 2
               rotation = 'varimax';
           end
           
           [lambda, psi, T, facstats] = factoran(X, k, 'rotate', rotation);
           
           stats.fitstats = facstats;
           stats.factors = lambda;
           stats.uniqueness = psi;
           stats.rotationMatrix = T;
           stats.SSfactors = sum(stats.factors .^ 2, 1);
           stats.proportionalVariance = stats.SSfactors ./ m;
       end
   end
end