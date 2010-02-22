function NatenbergDemo()

    figure();
    f = @(S,K) bs.call.price(S,K,0,.2,.05,60/260);
    fplot(@(S) [f(S,90) f(S,100) f(S,110)],[80 120]);
    title('Figure 6-4: Call Theoretical Value vs. Underlying Price');
    xlabel('Underlying Price');
    ylabel('Theoretical Value');
    legend('90','100','110','location','NorthWest');

    figure();
    f = @(S,K) bs.put.price(S,K,0,.2,.05,60/260);
    fplot(@(S) [f(S,90) f(S,100) f(S,110)],[80 120]);
    title('Figure 6-5: Put Theoretical Value vs. Underlying Price');
    xlabel('Underlying Price');
    ylabel('Theoretical Value');
    legend('90','100','110','location','NorthWest');
    
    figure();
    f = @(S,K) bs.call.delta(S,K,0,.2,.05,60/260);
    fplot(@(S) [f(S,90) f(S,100) f(S,110)],[80 120]);
    title('Figure 6-6: Call Delta vs. Underlying Price');
    xlabel('Underlying Price');
    ylabel('Theoretical Value');
    legend('90','100','110','location','NorthWest');

    figure();
    f = @(S,K) bs.put.delta(S,K,0,.2,.05,60/260);
    fplot(@(S) [f(S,90) f(S,100) f(S,110)],[80 120]);
    title('Figure 6-7: Put Delta Value vs. Underlying Price');
    xlabel('Underlying Price');
    ylabel('Theoretical Value');
    legend('90','100','110','location','NorthWest');    
    
    figure();
    f = @(S,K) bs.call.gamma(S,K,0,.2,.05,60/260);
    fplot(@(S) [f(S,90) f(S,100) f(S,110)],[80 120]);
    title('Figure 6-8: Call or Put Gamma vs. Underlying Price');
    xlabel('Underlying Price');
    ylabel('Gamma');
    legend('90','100','110','location','NorthEast');
    
    figure();
    f = @(t,K) bs.call.gamma(100,K,0,.2,.05,t/260);
    fplot(@(t) [f(t,90) f(t,100) f(t,110)],[0 200 0 .25]);
    title('Figure 6-9: Call or Put Gamma vs. Time to Expiration');
    xlabel('Time to Expiration (days)');
    ylabel('Gamma');
    legend('90','100','110','location','NorthEast');
    
    figure();
    f = @(s,K) bs.call.gamma(100,K,0,s,.05,60/260);
    fplot(@(s) [f(s,90) f(s,100) f(s,110)],[0 .4 0 .25]);
    title('Figure 6-10: Call or Put Gamma vs. Volatility');
    xlabel('Volatility');
    ylabel('Gamma');
    legend('90','100','110','location','NorthEast');
    
    figure();
    f = @(t,K) bs.call.delta(100,K,0,.2,.05,t/260);
    fplot(@(t) [f(t,90) f(t,100) f(t,110)],[0 200]);
    title('Figure 6-11: Call Delta vs. Time to Expiration');
    xlabel('Time to Expiration (days)');
    ylabel('Delta');
    legend('90','100','110','location','NorthWest');
    
    figure();
    f = @(t,K) bs.put.delta(100,K,0,.2,.05,t/260);
    fplot(@(t) [f(t,90) f(t,100) f(t,110)],[0 200]);
    title('Figure 6-12: Put Delta vs. Time to Expiration');
    xlabel('Time to Expiration (days)');
    ylabel('Delta');
    legend('90','100','110','location','NorthWest');
    
    figure();
    f = @(s,K) bs.call.delta(100,K,0,s,.05,60/260);
    fplot(@(s) [f(s,90) f(s,100) f(s,110)],[0 .4]);
    title('Figure 6-13: Call Delta vs. Volatility');
    xlabel('Volatility');
    ylabel('Delta');
    legend('90','100','110','location','NorthWest');    
    
    figure();
    f = @(s,K) bs.put.delta(100,K,0,s,.05,60/260);
    fplot(@(s) [f(s,90) f(s,100) f(s,110)],[0 .4]);
    title('Figure 6-13: Put Delta vs. Volatility');
    xlabel('Volatility');
    ylabel('Delta');
    legend('90','100','110','location','NorthWest');      
    
    