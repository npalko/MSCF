%{
Yahoo! Market Data downloader

Typical usage:
    f = marketdata.yahoo();
    [data dates] = f.getData('goog',today-20,today);
%}
classdef yahoo < handle
    properties
        debug = false
    end
    properties (Access = private)
       BASE_URL = 'http://ichart.finance.yahoo.com/table.csv'
       FREQUENCY = 'd'
       OUTPUT = '.csv'
    end
    methods
        function this = yahoo()
        end
        function [data dates] = getData(this, symbol, startDate, endDate)
            % retrieve data from Yahoo for a particular symbol and date 
            % range.
            
            url = this.getURL(symbol, startDate, endDate);
            [csv noError] = urlread(url);
            
            if noError
                
                % ignore the header row
                [ignore bytesRead] = textscan(csv, '%s', 1, ...
                    'delimiter', '\r');
                
                % data body
                % most recent data is retrieved first, so that data is 
                % flipped here so dates(end) = most recient date
                
                % Date,Open,High,Low,Close,Volume,Adj Close
                
                tmp = textscan(csv(bytesRead+1:end), '%s%f%f%f%f%f%f', ...
                    'delimiter', ',');
                
                dates = flipud(datenum(tmp{1}));
                data.open = flipud(tmp{2});
                data.high = flipud(tmp{3});
                data.low = flipud(tmp{4});
                data.close = flipud(tmp{5});
                data.volume = flipud(tmp{6});
                data.adjustedClose = flipud(tmp{7});
            else
                error('cloud:marketdata:yahoo','data failed to download');
            end
        end
    end
    methods (Access = private)
        function url = getURL(this, symbol, startDate, endDate)
            %{
            construct a URL representing the data request to the Yahoo API
            
            http://ichart.finance.yahoo.com/table.csv
                ?s=AAPL
                &a=10               start month - 1
                &b=15               start day
                &c=2005             start year
                &d=01               end month - 1
                &e=17               end day
                &f=2006             end year
                &g=d                daily frequency
                &ignore=.csv

            %}
            
            url = cell(1,10);
            url{1} = sprintf('%s?s=%s', this.BASE_URL, upper(symbol));
            url{2} = sprintf('&a=%d', month(startDate) - 1);
            url{3} = sprintf('&b=%d', day(startDate));
            url{4} = sprintf('&c=%d', year(startDate));
            url{5} = sprintf('&d=%d', month(endDate) - 1);
            url{6} = sprintf('&e=%d', day(endDate));
            url{7} = sprintf('&f=%d', year(endDate));
            url{8} = sprintf('&g=%d', this.FREQUENCY);
            url{9} = sprintf('&ignore=%s', this.OUTPUT);
            url = [url{:}];
            
            if this.debug
                fprintf('%s: URL=''%s''\r', mfilename(), url);
            end
        end
    end
end