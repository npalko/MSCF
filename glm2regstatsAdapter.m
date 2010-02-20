function stats = glm2regstatsAdapter(glm)
    % transform
    
    
    stats.beta = glm.beta;
    
    stats.tstat.beta = glm.beta;
    stats.tstat.se = glm.se;
    stats.tstat.t = glm.t;
    stats.tstat.pval = glm.p;
    stats.tstat.dfe = glm.dfe;
    
end