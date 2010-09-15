%{
  Black-Scholes-Merton pricing model

  phi     +1 for call; -1 for put
  x       spot price
  K       strike
  sigma   volatility
  T       time of expiration
  t       current time (default = 0)
  r       interest rate (default = 0)
  q       continuous dividend rate (default = 0)
  dplus   d_{+}
  dminus  d_{-}
%}

classdef bsm
  methods (Static)
    function [t r q] = optionalParameter(vin)
      optargs = {0 0 0};
      optargs(1:numel(vin)) = vin;
      [t r q] = optargs{:};
    end
    function f = f(x, T, t, r, q)
      f = x.*exp((r-q).*(T-t));
    end
    function dplus = dplus(x, K, sigma, T, t, r, q)
      f = bsm.f(x, T, t, r, q);
      dplus = (log(f./K) + (sigma.^2)/2*(T-t))./(sigma.*sqrt(T-t));
    end
    function dminus = dminus(x, K, sigma, T, t, r, q)
      dminus = bsm.dplus(x, K, sigma, T, t, r, q) - sigma.*sqrt(T-t);
    end
  end
  methods (Static)
    function price = price(phi, x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      f = bsm.f(x, T, t, r, q);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      dminus = bsm.dminus(x, K, sigma, T, t, r, q);
      price = phi .* exp(-r.*(T-t)) .* (f .* normcdf(phi.*dplus) - ...
        K.*normcdf(phi.*dminus));
    end
    function delta = forwardDelta(phi, x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      delta = phi .* normcdf(phi.*dplus);
    end
    function gamma = gamma(x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      gamma = exp(-q.*(T-t)) .* normpdf(dplus)./(x .* sigma .* sqrt(T-t));
    end
    function theta = theta(x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      theta = -exp(-q.*(T-t)) .* normpdf(dplus).*x.*simga./(2*sqrt(T-t));
    end
    function vega = vega(x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      vega = x .* exp(-q.*(T-t)) .* sqrt(T-t).* normpdf(dplus);
    end
    function varianceVega = varianceVega(x, K, sigma, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      dplus = bsm.dplus(x, K, sigma, T, t, r, q);
      varianceVega = x .* exp(-q.*(T-t)) .* sqrt(T-t)./(2.*sigma) .* ...
        normpdf(dplus);
    end
  end
  methods (Static)
    function ivol = ivol(phi, v, x, K, T, varargin)
      [t r q] = bsm.optionalParameter(varargin);
      objective = @(sigma)(v - bsm.price(phi, x, K, sigma, T, t, r, q))^2;
      options = optimset('Display', 'off', 'LargeScale', 'off');
      ivol = fminunc(objective, 0.15, options);
    end
    function m = moneyness(x, K, sigma, T, varargin)
      [t r] = bsm.optionalParameter(varargin);
      m = (log(x/K) + r*(T-t)) / (sigma*sqrt(T-t));
    end
  end
end
