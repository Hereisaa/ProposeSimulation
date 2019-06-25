clc, clear all, close all

numNodes = 300; % number of nodes
p = 0.05; % ratio of number of CH (default)
d0 = 87; % distance threshold
T1 = 100; T2 = 87; % canopy threshold
netArch  = newNetwork(500, 500, 250, 250); % (Network Length, Network  Width, BS_x, BS_y)
init_nodeArch = newNodes(netArch, numNodes);
proposed_nodeArch = init_nodeArch; % node's arch for proposed



%%%%%% Layer Phase
%%%%%% Initial
for i= 1:proposed_nodeArch.numNode
    proposed_nodeArch.node(i).CID = 0;
end

count = 1; % no of nodes that are not in Layer 0.
d = d0;
% Temp : all nodes \ {nodes in Layer 0}

% Layer marking 
for i = 1:numNodes
    dist = calDistance(proposed_nodeArch.node(i).x, proposed_nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
    if( dist > d )
        if( dist > 2*d )
            proposed_nodeArch.node(i).Layer = 2;
        else
            proposed_nodeArch.node(i).Layer = 1;
        end
        Temp_xy(1, count) = proposed_nodeArch.node(i).x;
        Temp_xy(2, count) = proposed_nodeArch.node(i).y;
        Temp_index(1, count) = i;
%         Temp(count).x = proposed_nodeArch.node(i).x;
%         Temp(count).y = proposed_nodeArch.node(i).y;
%         Temp_index(1, count) = i;
        count = count + 1;
    else
        proposed_nodeArch.node(i).Layer = 0;
    end
end


[ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 );
plot_canopy

