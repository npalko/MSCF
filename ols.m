classdef ols < handle
   methods (Static)
       function s = summmary(stats, fields)
           
           t = stats.tstat;
           fields = [{'(Intercept)'} fields]';
           
           s = [ {[],'Value', 'Std Error', 't value', 'Pr(>|t|)'}
                 [fields num2cell([t.beta t.se t.t t.pval])] 
               ];
           

       end
       function anova()
           
            fprintf('\r')
            fprintf('Regression ANOVA');
            fprintf('\r\r')

            fprintf('%6s','Source');
            fprintf('%10s','df','SS','MS','F','P');
            fprintf('\r')

            fprintf('%6s','Regr');
            fprintf('%10.4f', f.dfr, f.ssr, f.ssr/f.dfr, f.f, f.pval);
            fprintf('\r')

            fprintf('%6s','Resid');
            fprintf('%10.4f',f.dfe ,f.sse, f.sse/f.dfe);
            fprintf('\r')

            fprintf('%6s','Total');
            fprintf('%10.4f', f.dfe+f.dfr, f.sse+f.ssr);
            fprintf('\r')
    
       end
       function diagnose()
        %{








        regstats

            Durbin-Watson statistic







        %}


            % Check for the violation of any of the following assumptions
            %  1. linearity
            %  2. homoscedasticity
            %  3. non-normality
            %  4. independence of errors



           
           
       end 
   end
end