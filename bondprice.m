%{
Copyright (c) 2009, npalko@tepper.cmu.edu. All rights reserved.



Typical usage:
    
    price = bondprice(100,.10,8,.05);
    fsolve(@(y) 119.23 - bondprice(100,y,8,.05));
        

%}
function price = bondprice(face, yield, maturity, coupon)


    nCompound = 2;  % semi-annual compounding convention

    couponPayment = coupon/nCompound*face;
    cashflows = repmat(couponPayment, 1, nCompound*maturity);
    cashflows(end) = cashflows(end) + face;
    
    discount = repmat(1/(1+yield/2),1, nCompound*maturity);
    discount = discount.^(1:nCompound*maturity);
    
    price = sum(cashflows .* discount);

end