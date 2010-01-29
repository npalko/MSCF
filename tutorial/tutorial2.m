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

gbm = @(S,t) process.geometricbrownianmotion(S,t,.1,.8);
ou = @(S,t) process.ornsteinuhlenbeck();

montecarlo(gbm, 100, 100)

% Plotting. Notice that FPLOT doesn't care what's going on inside the 
% function passed to it. FPLOT simply provides an X coordinate, and 
% recieves a Y back. 

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


% look at historical volitlity


% calucalte returns
% preform regression



% trade signals
%


