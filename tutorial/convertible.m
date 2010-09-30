
  
  x = 33.32;
  r = 0.0025;
  q = 0;
  T = (datenum('26-sep-2014')-today())/365;
  k = [45.4104 60.1020];
  sigma = [0.30 0.25];
  ticker = 'GILD';
  company = 'Gilead Sciences Inc.';
  
  % payoff table
  tbl.price = bsm.price(1,x,k,sigma,T,0,r,q);
  tbl.delta = bsm.delta(1,x,k,sigma,T,0,r,q);
  tbl.gamma = bsm.gamma(x,k,sigma,T,0,r,q);
  tbl.theta = bsm.theta(x,k,sigma,T,0,r,q);
  tbl.vega = bsm.vega(x,k,sigma,T,0,r,q);
  [tbl.price; tbl.delta; tbl.gamma; tbl.theta; tbl.vega;]'
  
  % payoff plot
  payoff = @(cost,x,K) max([x-K, 0]) - cost;
  %portfolioPayoff = @(x) payoff(tbl.price, x, k) * portfolio;
  portfolioPayoff = @(x) -payoff(tbl.price(1),x,k(1)) + payoff(tbl.price(2),x,k(2));
  
  [px py] = fplot(portfolioPayoff, [35 70 -20 10]);
  fig = figure();
  plot(px, py, 'LineWidth', 2)
  set(gca(), 'YLim', [-20,10])
  ylabel('Payoff')
  xlabel('S_{T}')
  title('Payoff at Expiration')
  saveas(fig, 'figure-1.emf', 'emf')
  
  % Risk plot
  f.delta = @(x) bsm.delta(1,x,k,sigma,1/52,0,r,q) * portfolio;
  f.gamma = @(x) bsm.gamma(x,k,sigma,1/52,0,r,q) * portfolio;
  f.vega = @(x) bsm.vega(x,k,sigma,1/52,0,r,q) * portfolio;
  
  xRange = [35 70];
  [x1 y1] = fplot(f.delta, xRange);
  [x2 y2] = fplot(f.gamma, xRange);
  fig = figure();
  [ax h(1) h(2)] = plotyy(x1, y1, x2, y2);
  set(h(1), 'LineWidth', 2)
  set(h(2), 'LineWidth', 2)
  set(get(ax(1),'Ylabel'), 'String', 'Delta')
  set(get(ax(2),'Ylabel'), 'String', 'Gamma')
  xlabel('Spot')
  title('Delta and Gamma 1 Week To Expiry')
  saveas(fig, 'figure-2.emf', 'emf')
  

  
  
  
  
  