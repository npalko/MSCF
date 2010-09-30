function varianceSwapDemo(K)

  inverseWeight = (1./K.^2)./sum(1./K.^2);
  equalWeight = ones(1,numel(K))./numel(K);
  
  f = @(x) bsm.varianceVega(x, K, .2, 1);
  g = @(x) bsm.gamma(x, K, .2, 1);
  
  [x y] = fplot(g, [20 180]);
  
  figure();
  plot(x,y);
  
  inversePortfolio = y.^2 * inverseWeight';
  equalPortfolio = y.^2 * equalWeight';
  
  figure();
  plot(x, [inversePortfolio equalPortfolio]);
  
  

  