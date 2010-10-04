function h = publicationfigure(varargin)

  h = figure();
  
  width = 4.00;
  units = 'inches';
  
  % Resize to specified width
  %goldenratio = (1+sqrt(5))/2;
  goldenratio = 1.45;
  height = width/goldenratio;
  
  set(h, 'PaperUnits', units);
  set(h, 'PaperSize', [width height]);
  set(h, 'PaperPositionMode', 'manual');
  set(h, 'PaperPosition', [0 0 width height]);
  
  set(h, 'Units', units);
  set(h, 'Position', [0 0 width height]);
end