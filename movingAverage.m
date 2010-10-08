function m = movingAverage(x, n, noDataValue)

  if nargin == 2
    noDataValue = NaN;
  end

  m = filter(ones(1,n)/n,1,x);
  m(1:(n-1)) = noDataValue;
end