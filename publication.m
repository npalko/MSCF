function publication(varargin)
% hFigure, width


%Tobin Fricke
%nibot_lab@livejournal.com	
%http://nibot-lab.livejournal.com/73290.html

Latin Modern





goldenratio = (1+sqrt(5))/2;


% Eliminate whitespace around figure
set(gca, 'Position', get(gca, 'OuterPosition') - ...
    get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
    
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6.25 7.5]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 6.25 7.5]);

 
 end