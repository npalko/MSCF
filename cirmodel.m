classdef cirmodel < handle
  properties
    beta
    kappa
    theta
  end
    methods
      function this = cirmodel(beta, kappa, theta)
        this.beta = beta;
        this.kappa = kappa;
        this.theta = theta;
      end
      function B = B(this, s, x_t)
        B = exp(-this.a(s)-this.b(s).*x_t);
      end
      function r = r(this, t, T, B)
        r = -(log(B)+this.a(T-t))/this.b(T-t);
      end
    end
    methods
      function a = a(this, s)
        g = sqrt(this.kappa^2 + 2*this.beta^2);
        a = -(2*this.kappa*this.theta/(this.beta^2)) * ( ...
          log(2*g) + 1/2*(this.kappa+g)*s - ...
          log((g+this.kappa)*(exp(g*s)-1)+2*g));
      end
      function aprime = ap(this, s)
        aprime = this.kappa*this.theta*this.b(s);
      end
      function b = b(this, s)
        g = sqrt(this.kappa^2 + 2*this.beta^2);
        b = 2*(exp(g*s)-1)./((g+this.kappa)*(exp(g*s)-1)+2*g);
      end
      function bprime = bp(this, s)
        bprime = 1-1/2*this.beta^2*this.b(s).^2-this.kappa*this.b(s);
      end
      function x = path(this, x_0, T, m, n)  
        dt = T/m;
        Z = randn([n,m]);
        x = zeros([n,m]);

        x(:,1) = x_0;
        for i=1:(m-1)        
          x(:,i+1) = x(:,i) + this.kappa.*(this.theta-x(:,i)).*dt + ...
            this.beta.*sqrt(max(0, x(:,i)).*dt).*Z(:,i);
        end
      end
    end
end
