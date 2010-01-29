classdef call < handle
    methods
        function this = call()
        end
        function display(this)
            fprintf('<call>\r');
        end
        function disp(this)
            display(this);
        end
    end
    methods (Static)
        function C = price(S, K, t, vol, r, T)
            
            d1 = bs.d1(S, K, t, vol, r, T);
            d2 = bs.d2(S, K, t, vol, r, T);
            C = S*normcdf(d1) - K*exp(-r*(T-t))*normcdf(d2);
        end
        function charm = charm(S, K, t, vol, r, T)
        end
        function delta = delta(S, K, t, vol, r, T)
            
            d1 = bs.d1(S, K, t, vol, r, T);
            delta = normcdf(d1);
        end
        function gamma = gamma(S, K, t, vol, r, T)
            
            d1 = bs.d1(S, K, t, vol, r, T);
            gamma = normpdf(d1) /(S * vol * (T-t));
        end
        function volga = volga(S, K, t, vol, r, T)
            
            d1 = bs.d1(S, K, t, vol, r, T);
            d2 = bs.d2(S, K, t, vol, r, T);
            
            volga = S*sqrt(T-t)*normpdf(d1)*d1*d2/vol;
        end
    end
end

