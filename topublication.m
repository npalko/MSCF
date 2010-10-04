%{


%}

function topublication(h, varargin)

  ca = get(h, 'CurrentAxes');
  
  % Match LaTeX font
  set(ca, 'FontName', 'LatinModern');

  % Eliminate whitespace around figure
  set(ca, 'Position', get(ca, 'OuterPosition') - ...
    get(ca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
end