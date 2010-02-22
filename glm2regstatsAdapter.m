function stats = glm2regstatsAdapter(glm)
    % transform the output of GLM fit to match that of REGSTATS. not all 
    % variables are transformed.
    
    
    stats.beta = glm.beta;
    
    stats.tstat.beta = glm.beta;
    stats.tstat.se = glm.se;
    stats.tstat.t = glm.t;
    stats.tstat.pval = glm.p;
    stats.tstat.dfe = glm.dfe;
    
end