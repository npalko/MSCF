function price = bondprice(face, yield, maturity, coupon, nCompound)
%{
Typical usage:

    price = bondprice(face, yield, maturity, coupon, nCompound);
    price = bondprice(100,.10,8,.05);
    fsolve(@(y) 119.23 - bondprice(100,y,8,.05));
     
%}

    nCashflows = nCompound * maturity;
    
    couponPayment = coupon/nCompound*face;
    cashflows = repmat(couponPayment, 1, nCashflows);
    cashflows(end) = cashflows(end) + face;
    
    singlePeriodDiscount = 1/(1+yield/nCompound);
    periodCompound = (1:nCashflows);
    discount = repmat(singlePeriodDiscount, 1, nCashflows);
    discount = discount.^periodCompound;
    
    price = sum(cashflows .* discount);

end