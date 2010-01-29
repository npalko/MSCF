%{
TUTORIAL CONFIGURATION
* make sure you have your MATLAB path set to include
    C:\Users\Nicholas Palko\Documents\Development\MSCF    
    C:\Users\Nicholas Palko\Documents\Development\Cloud\MATLAB\cloud
    


STYLE:

* spaces instead of tabs: other people use different tab settings; spaces
  guarentee consistency
* don't write past 80 lines (use ...): this helps when you want to look at
  two pages of code side by side; we'll visit such situations when using
  source control later

COMMENTS:

Zen of commenting:

        Your code should be clear enough to tell someone HOW
        you are doing something; comments should tell them
        WHY the code exists

GOOD CODING GUIDELINES:

1. use intermediate variables with specific names to explain your thought
   process
2. don't hardcode constants (i.e. no random numbers showing up in code)
3. code is written a few times, and then read hundreds of times. make 
   make your code readable!!
4. optimization is the very last thing you ever do! don't write code to use
   obscure tricks to 'make things go faster'. 
%}




%{
ANONYMOUS FUNCTIONS: BOND PRICING, OPTION GREEKS
NAMESPACES

%}

% Basic examples of anonymous functions

f1 = @(x) x^2;
f2 = @(x) sin(x);
f3 = @(y) bondprice(100,y,10,.04);

% Why is it important? This way, you can pass a function to a function 
%
%           Yo Dawg, I heard you like functions, so I
%           put a function in your function so that  
%           you can MATLAB while you MATLAB.
%               ref: http://knowyourmeme.com/memes/xzibit-yo-dawg
%
% Anonymous functions are 1st class objects (a good interview question).
% This means that anonymous functions can be passed around like any other
% object in MATLAB (like a matrix, string, cell array, etc). This 
% allows us to ENCAPSULATE and RESUSE our hard work

% Plotting. Notice that FPLOT doesn't care what's going on inside the 
% function passed to it. FPLOT simply provides an X coordinate, and 
% recieves a Y back (ENCAPSULATION!). 

fplot(@(x) sin(x),[1 10*pi]);
f = @(x) sin(x);
fplot(f, [1 10*pi]);
fplot(@(x) [sin(x) sin(4*x) sin(8*x)], [1 pi]);

% Anonymous functions are also useful for finding solutions that can only
% be obtained numerically

f = @(y) bondprice(100,y,8,.05);
fplot(f, [0 .1]);

% (use data explorer)

f = @(y) 119.23 - bondprice(100,y,8,.05);
y = fsolve(f, 0);
fsolve(@(y) 119.23 - bondprice(100,y,8,.05), 0);

% formating

format('short')
format('long')

% Namespaces: Those funky folders with the '+'. Essentially, they're a way
% of organizing all the functions available to us. NEVER ADD THESE FOLDERS
% TO YOUR PATH; add the parent folder instead.

% Staic methods: to invoke the method without an instance of the class

% Below, we use:
% [use the bs namespace].[the call object].[the static method of the call]

% Recreating options plots out of Natenberg

cp = @(S,K) bs.call.price(S,K,0,.2,.05,60/260);
fplot(@(S) [cp(S,90) cp(S,100) cp(S,110)],[80 120]);
title('Figure 6-4: Call Theoretical Value vs. Underlying Price');
xlabel('Underlying Price');
ylabel('Theoretical Value');
legend('90','100','110','location','NorthWest');

cg = @(S,K) bs.call.gamma(S,K,0,.2,.05,60/260);
fplot(@(S) [cg(S,90) cg(S,100) cg(S,110)],[80 120]);
title('Figure 6-8: Call or Put Gamma vs. Underlying Price');
xlabel('Underlying Price');
ylabel('Gamma');
legend('90','100','110','location','NorthEast');

%{
DEBUGGING: BEST WAY TO ANSWER 'WHAT THE HELL IS GOING ON?!'


Let's revisit bondprice.m

>> edit bondprice.m

1. set breakpoint in bondprice
2. Observe that the stack frame changes. Workspace variables are no
   longer local. Observe change in prompt.

dbcont: continue until next breakpoint
dbquit: give up
dbclear all: clear all breakpoints

%}


%{
SERIAL DATES

The best way to work with dates in MATLAB. Extremely useful when plotting
time series. Also see 

    Financial Toolbox | Function Reference | Dates | Financial Dates

%}

today()
m2xdate(today())
datestr(today())
datestr(today(), 'yyyy-mm-dd')
datestr(now())
datenum('12-25-1981')

%{
DOWNLOADING MARKET DATA

%}

portfolio.ticker = {
    'SPY'
    'XLU' 
    'XLK' 	
    'XLF' 	
    'XLE' 
    'XLY'
    'XLV'
    };
portfolio.description = {
    'S&P 500 (ETF)'
    'Utilities SPDR (ETF)'
    'Technology SPDR (ETF)'
    'Financial Select Sector (ETF)'
    'Energy Select Sector SPDR (ETF)'
    'Consumer Discretionary SPDR (ETF)'
    'Health Care SPDR (ETF)'
    };
endDate = today - 1;
startDate = endDate-500;

f = marketdata.yahoo();
f.debug = true;

% determine how big we need to make our preallocation

[ignore dates] = f.getData(portfolio.ticker{1}, startDate, endDate);
nDate = numel(dates);
nSecurity = numel(portfolio.ticker);
close = zeros(nDate, nSecurity);
volume = zeros(nDate, nSecurity);

for i=1:nSecurity
   [download ignore] = f.getData(portfolio.ticker{i}, startDate, endDate);
   close(:,i) = download.close;
   volume(:,i) = download.volume;
end

% notice that with our data already arranged in a certian way (each
% column is a different security), MATLAB does the right thing
% automatically

plot(dates,close);
datetick('x','mmm-yy');
legend(portfolio.ticker);


%{
TIME SERIES BASICS

* all time series matricies indexed as A(time,security)
* A(1,:) is the first temperal observation, A(end,:) is the last

Remember your ABVs:
    
    Always
    Be
    Vectorizing

In MATLAB, we shouldn't have to write many for loops. If you're writing a
for loop, stop and think if there's a different approach. Your code will 
be 
 * more readable (MOST IMPORTANT!), as it will be more idiomatic MATLAB, 
   and make sense to other people who use MATLAB
 * about 1-1000x times faster. Not only because vectorization is faster, 
   but for loops in MATLAB are really really really really slow.

%}

% calculate simple returns
% (Vf-Vi)/Vi
% notice that for time index 1 we have no returns defined, as we do not
% have a price for time index 0.

ret = NaN(size(close));
ret(2:end,:) = (close(2:end,:) - close(1:end-1,:)) ./ close(1:end-1,:);

% look at historical volitlity

vol = NaN(size(ret));
window = 20; % use a 20-day trailing volatility

for i=window:size(ret,1)
    vol(i,:) = nanstd(ret(i-window+1:i,:));
end

vol = vol * sqrt(260); % annualize daily observations

%{
TRADING SIMULATION


%}

% lets create some trade signals

signal = rand(size(close));
action = zeros(size(close));

buySign = (signal > .15) & (signal < .20);
sellSign = (signal > .75) & (signal < .80);

action(buySign) = 1;
action(sellSign) = -1;

% simple cumsum example
stairs(cumsum(double(action(:,1))));

trade = action .* volume * .02; % only get as big as 2% volume


% define position as end of day quantites

qty = cumsum(trade);
exposure = qty .* close;

% pnl
% (P(t) - P(t-1)) * Q(t)

pnl = zeros(size(close));
pnl(2:end,:) = (close(2:end,:) - close(1:end-1,:)) .* qty(2:end,:);

plot(cumsum(sum(pnl,2)))


%{
LINEAR REGRESSION AND PLOTTING

%}


xLim = [min(x) max(x)];
[b bint r rint stats] = regress(y, [ones(size(x)) x]);
[xRegress yRegress] = fplot(@(t) b(1) + b(2)*t, xLim);

figure();
line(x, y, 'Parent', gca(),'Marker','.','Line','None'); % scatter
line(xRegress, yRegress, 'Parent', gca(), 'Color', 'red'); % line
    
    

