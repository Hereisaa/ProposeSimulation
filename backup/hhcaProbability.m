function P = leachProbability(r, p)
% Probability function for elect the node as CH
%   Input:
%       r     round no
%       p     p
%   Example:
%       P = leachProbability(1, 0.05);

    if ~exist('p','var')
        p = 0.1;
    end

    P = p / (1-p * mod(r, round(1 / p)));
    
%     P = p;
    
end