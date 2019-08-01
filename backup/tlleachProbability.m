function P = tlleachProbability(r, p)
% Probability function for elect the node as CH

    P = p / (1-p * mod(r, round(1 / p)));
%     P = p * mod((r + 1),round(1/p));
end