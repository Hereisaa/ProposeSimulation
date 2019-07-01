function [ SCH, SRN ] = calSelection( E_res, E_avg, d_Centr, d_toCentr, d_BS, d_toBS  )
% calculate SCH 
%   E_res : residual energy of node i
%   E_avg : avg energy (in this cluster)
%   d_Centr : distance of node i to centr
%   d_toCentr : avg distance of nodes to centr (in this cluster)
%   d_BS : distance of node i to BS
%   d_toBS : avg distance of nodes to BS (in this cluster)

    a = 0.5;  b = 0.5;
    
    SCH = a * (E_res / E_avg) + b * ( 1 - (d_Centr / d_toCentr) );
    SRN = a * (E_res / E_avg) + b * ( 1 - (d_BS / d_toBS) );
end

