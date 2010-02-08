function anova(f)
    % print analysis of variance
    


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
