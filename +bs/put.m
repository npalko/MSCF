classdef put < handle
    methods
        function this = put()
        end
        function display(this)
            fprintf('<call>\r');
        end
        function disp(this)
            display(this);
        end
    end
    methods (Static)
        function P = price(S, K, t, vol, r, T, q)
            
            if nargin == 6, q = 0; end
            
            d1 = bs.d1(S, K, t, vol, r, T, q);
            d2 = bs.d2(S, K, t, vol, r, T, q);            
            P = -S*exp(-q*(T-t))*normcdf(-d1) + K*exp(-r*(T-t))*normcdf(-d2);
        end
        function c = charm
        end
    end
end

