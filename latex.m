classdef latex < handle
  properties (Access=private)
    f
    header = []
    align = []
    useRowLine = false
  end
  methods 
    function this = latex2()
    end
    function delete(this)
      try
        fclose(this.f);
      catch me
        if ~strcmp(me.identifier,'MATLAB:FileIO:InvalidFid')
          rethrow(me);
        end
      end
    end  
    function setHeader(this, header)
      this.header = header;
    end
    function setAlign(this, align)
      this.align = align;
    end
    function setUseRowLine(this, useRowLine)
      this.useRowLine = useRowLine;
    end
    function write(this, filename, data)
      
      [nRow nCol] = size(data);
      this.f = fopen(filename, 'w');
      fprintf(this.f, '\\begin{tabular}{%s}\n', this.getAlign(nCol));
      
      if ~isempty(this.header)
        fprintf(this.f, '\\hline\n')
        for j=1:nCol-1
          fprintf(this.f, '%s &', this.header{j});
        end
        fprintf(this.f, '%s\\tabularnewline\n', this.header{nCol});
        fprintf(this.f, '\\hline\n');
      end
      
      fprintf(this.f, '\\hline\n');
      for i=1:nRow
        for j=1:nCol
          if (j == nCol)
            fprintf(this.f, '%s\\tabularnewline\n', data{i,j});
            if this.useRowLine || (i==1) || (i==nRow);
              fprintf(this.f, '\\hline\n');
            end
          else
            fprintf(this.f, '%s &', data{i,j});
          end
        end
      end
 
      fprintf(this.f, '\\end{tabular}\n');
      fclose(this.f);
    end
  end
  methods (Access=private)
    function align = getAlign(this, nCol)
      if isempty(this.align)
        align = [repmat('|c',1,nCol) '|'];
      else
        align = this.align;
      end
    end
   
  end
end