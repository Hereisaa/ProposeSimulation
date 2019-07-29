function [ SCH, SRN ] = calSelection( E_res, E_avg, E_max, E_min, d_Centr, d_toCentr, d_BS, d_toBS, maxToCentr, minToCentr, maxToBS, minToBS )
% calculate SCH 
%   E_res : residual energy of node i
%   E_avg : avg energy (in this cluster)
%   d_Centr : distance of node i to centr
%   d_toCentr : avg distance of nodes to centr (in this cluster)
%   d_BS : distance of node i to BS
%   d_toBS : avg distance of nodes to BS (in this cluster)

    a = 0.5;  b = 0.5;
    
%     SCH = a * (E_res / E_avg) + b * ( 1 - (d_Centr / d_toCentr) );
%     SRN = a * (E_res / E_avg) + b * ( 1 - (d_BS / d_toBS) );
%     
    x = (E_res - E_min) / (E_max - E_min);
    y = (d_Centr - minToCentr) / (maxToCentr - minToCentr);
    z = (d_BS - minToBS) / (maxToBS - minToBS);
    x(isnan(x)==1) = 0;
    y(isnan(y)==1) = 0;
    z(isnan(z)==1) = 0;
    SCH = a * x + b * ( 1 - y );
    SRN = a * x + b * ( 1 - z );

%     SCH = a * ((E_res) / (E_max)) + b * ( 1 - ((d_Centr) / (maxToCentr)) );
%     SRN = a * ((E_res) / (E_max)) + b * ( 1 - ((d_BS) / (maxToBS)) );
    
%     SCH = ( 1 - (d_Centr / d_toCentr) );
%     SRN = ( 1 - (d_BS / d_toBS) );
end

