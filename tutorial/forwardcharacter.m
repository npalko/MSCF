% forwardcharacter.m

x = 50;
portfolio = [-1; 1]; % long call short put
K = @(p) 50*[(1-p) 1+p];
sigma = [0.20 0.20];
T = 1/12;
r = 0.0025;
q = 0;

call = @(x,k,cost) max([x-k,0]) - cost;
put = @(x,k,cost) max([k-x,0]) - cost;
payoff = @(x,k) call(x,k(1),1)-put(x,k(2),1);



f.delta = @(x,p) bsm.forwardDelta(portfolio',x,K(p),sigma,T,0,r,q) * portfolio;
f.gamma = @(x,p) bsm.gamma(x,K(p),sigma,T,0,r,q) * portfolio;
f.vega = @(x,p) bsm.vega(x,K(p),sigma,T,0,r,q) * portfolio;


xRange = [35 65];

fig = figure();
[x1 y1] = fplot(@(x) [payoff(x,K(.01)) payoff(x,K(.04)) payoff(x,K(.1))],xRange);
plot(x1, y1, 'LineWidth', 2)
legend('1.0%','5.0%','10.0%','Location','SouthEast')
xlabel('Spot')
ylabel('Reversal Payoff')
saveas(fig, 'figure-5.emf', 'emf')

fig = figure();
[x1 y1] = fplot(@(x) [f.delta(x,0.01) f.delta(x,0.05) f.delta(x,0.10)], xRange);
plot(x1, y1, 'LineWidth', 2)
legend('1.0%','5.0%','10.0%','Location','SouthEast')
xlabel('Spot')
ylabel('Delta')
saveas(fig, 'figure-3.emf', 'emf')


fig = figure();
[x1 y1] = fplot(@(x) [f.gamma(x,0.01) f.gamma(x,0.05) f.gamma(x,0.10)], xRange);
plot(x1, y1, 'LineWidth', 2)
legend('1.0%','5.0%','10.0%','Location','SouthEast')
xlabel('Spot')
ylabel('Gamma')
saveas(fig, 'figure-4.emf', 'emf')


