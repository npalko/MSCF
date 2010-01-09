%{
TUTORIAL CONFIGURATION

spaces
don't write past 80 lines

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
% This means that functions can be passed around like any other object in
% MATLAB (like a matrix, string, cell array, etc). This functionality 
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
fsolve(@(y) 119.23 - bondprice(100,y,8,.05));

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

og = @(S,K) bs.call.gamma(S,K,0,.2,.05,60/260);
fplot(@(S) [og(S,90) og(S,100) og(S,110)],[80 120]);
title('Figure 6-8: Call or Put Gamma vs. Underlying Price');
xlabel('Underlying Price');
ylabel('Gamma');
legend('90','100','110','location','NorthEast');

%{
DEBUGGING: BEST WAY TO ANSWER 'WHAT THE HELL IS GOING ON?!'

%}

% 1. set breakpoint in bondprice
% 2. Observe that the stack frame changes. Workspace variables are no
%    longer local. Observe change in prompt

% dbcont: continue until next breakpoint
% dbquit: give up
% dbclear all: clear all breakpoints

% Good coding guidelines:
% 1. use intermediate variables with specific names to explain your thought
%    process
% 2. don't hardcode constants (i.e. no random numbers showing up in code)
% 3. code is written a few times, and then read hundreds of times. make 
%    make your code readable!!




%{
DOWNLOADING MARKET DATA

%}



%{
SEND EMAIL
http://stackoverflow.com/questions/46663/how-do-you-send-email-from-a-java-app-using-gmail

%}









%{
TIME SERIES BASICS

* all time series matricies indexed as A(time,security)
* A(1,:) is the first temperal observation, A(end,:) is the last

%}