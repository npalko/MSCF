classdef vasicek < handle
  properties
    beta
    kappa
    theta
  end
  methods
    function this = vasicek(beta, kappa, theta)
      this.beta = beta;
      this.kappa = kappa;
      this.theta = theta;
    end
    function b = b(this, tau)
      b = 1/this.kappa*(1-exp(-this.kappa*tau));
    end
    function a = a(this, tau)
      a = (this.theta - 1/2*(this.beta/this.kappa)^2) * ...
        (tau - this.b(tau)) + (this.beta*this.b(tau)).^2/(4*this.kappa);
    end
    function m = mean(this, x_0,t,T)  
      m = this.theta + (x_0-this.theta)*exp(-this.kappa*(T-t));
    end
    function v = var(this,t,T)
      v = this.beta^2/(2*this.kappa)*(1-exp(-2*this.kappa*(T-t)));
    end
    function B = B(this, tau, x_0)
      B = exp(-this.a(tau) -this.b(tau)*x_0);
    end
    function x = path(this, x_0, T, m, n)
      dt = T/m;
      Z = randn([n,m]);
      x = zeros([n,m]);
  
      x(:,1) = x_0;
      for i=1:(m-1)
        x(:,i+1) = x(:,i) + this.kappa*(this.theta - x(:,i))*dt + ...
          this.beta*sqrt(dt)*Z(:,i+1);
      end
    end
  end
end