function P = hhcaProbability(r, p)

    if ~exist('p','var')
        p = 0.1;
    end

    P = p / (1-p * mod(r, round(1 / p)));
    
%     P = p;
    
end