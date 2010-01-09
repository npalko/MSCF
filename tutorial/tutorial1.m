


java.net.InetAddress.getLocalHost();



portfolio.ticker = {
    'NYSE:XLU' 
    'NYSE:XLK' 	
    'NYSE:XLF' 	
    'NYSE:XLE' 
    %'NYSE:XLY'
    %'NYSE:XLV'
    }';
portfolio.description = {
    'Utilities SPDR (ETF)'
    'Technology SPDR (ETF)'
    'Financial Select Sector (ETF)'
    'Energy Select Sector SPDR (ETF)'
    %'Consumer Discretionary SPDR (ETF)'
    %'Health Care SPDR (ETF)'
    }';


endDate = today - 1;
startDate = endDate-500;

f = marketdata.google();
f.debug = true;


[ignore dates] = f.getData(portfolio.ticker{1}, startDate, endDate);

nDate = numel(dates);
nSecurity = numel(portfolio.ticker);

high = zeros(nDate, nSecurity);
low = zeros(nDate, nSecurity);
close = zeros(nDate, nSecurity);

for i=1:nSecurity
   [data securityDates] = f.getData(portfolio.ticker{i}, startDate, endDate);
   
   [ignore loc] = ismember(securityDates,dates);
   
   high(loc,i) = data.high;
   low(loc,i) = data.low;
   close(loc,i) = data.close;
end

plot(dates,close);
datetick('x','mmm')
legend(portfolio.description)

noise = rand([nDate,nSecurity])-1/2;

std(noise)
mean(noise)
cumsum(noise)

trade = [0 0 0 5 30 -5 -20 0 0 0 0]
position = cumsum(trade)


h = @(x) {datestr(x,'dd-mmm-yyyy')};
arrayfun(h,(today-20):1:today)
sparse()
single()









