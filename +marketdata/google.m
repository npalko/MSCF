%{
Google Market Data downloader

Typical usage:
    f = marketdata.google();
    [data dates] = f.getData('nasdaq:aapl',today-20,today);
%}
classdef google < handle
    properties
        debug = false
    end
    properties (Access = private)
       BASE_URL = 'http://www.google.com/finance/historical'
       OUTPUT = 'csv'
    end
    methods
        function this = google()
        end
        function [data dates] = getData(this, symbol, startDate, endDate)
            % retrieve data from Google for a particular symbol and date 
            % range
            
            url = this.getURL(symbol, startDate, endDate);
            [csv noError] = urlread(url);
            
            if noError
                
                % read the header row
                [ignore bytesRead] = textscan(csv, '%s', 1);
                
                % data body
                % most recient data is retrieved first, so that data is 
                % flipped here so dates(end) = most recient date
                
                tmp = textscan(csv(bytesRead+1:end), '%s%f%f%f%f%f', ...
                    'delimiter', ',');
                
                dates = flipud(datenum(tmp{1}));
                data.open = flipud(tmp{2});
                data.high = flipud(tmp{3});
                data.low = flipud(tmp{4});
                data.close = flipud(tmp{5});
                data.volume = flipud(tmp{6});
            else
                error('cloud:marketdata:google','data failed to download');
            end
        end
    end
    methods (Access = private)
        function url = getURL(this, symbol, startDate, endDate)
            %{
            construct a URL representing the data request to the Google API
            
            http://www.google.com/finance/historical
                ?q=NASDAQ:GOOG
                &startdate=Sep+30,+2008
                &enddate=Sep+30,+2009
                &output=csv
            %}
            
            url = cell(1,4);
            url{1} = sprintf('%s?q=%s', this.BASE_URL, upper(symbol));
            url{2} = sprintf('&startdate=%s', datestr(startDate,'mmm+dd,+yyyy'));
            url{3} = sprintf('&enddate=%s', datestr(endDate,'mmm+dd,+yyyy'));
            url{4} = sprintf('&output=%s', this.OUTPUT);
            
            url = [url{:}];
            
            if this.debug
                fprintf('%s: URL=''%s''\r', mfilename(), url);
            end
        end
    end
end