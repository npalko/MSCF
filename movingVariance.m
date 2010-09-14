function v = movingVariance(x, n, noDataValue)

  if nargin == 2
    noDataValue = NaN;
  end

  x2 = filter(ones(1,n),1,x.^2);
  xbar = movingAverage(x, n, noDataValue);
  v = (x2-n*xbar.^2)/(n-1);
  v(1:(n-1)) = noDataValue;
end