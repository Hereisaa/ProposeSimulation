function [ Model, Temp_xy, Temp_index, notLayerZero ] = NetworkDimension( Model, d_th, netArch )
%Network Dimension Phase
    nodeArch = Model.nodeArch;
    notLayerZero = 0; % no of nodes that are not in Layer 0.
%     d_th = d0;
    % Temp : all nodes \ {nodes in Layer 0}
    % Layer marking using threshold d_th for each layer
    for i = 1:nodeArch.numNode
        dist = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
        if( dist > d_th )
            if( dist > 2*d_th )
                nodeArch.node(i).Layer = 2;
            else
                nodeArch.node(i).Layer = 1;
            end
            Temp_xy(1, notLayerZero + 1) = nodeArch.node(i).x;
            Temp_xy(2, notLayerZero + 1) = nodeArch.node(i).y;
            Temp_index(1, notLayerZero + 1) = i;
    %         Temp(inLayer0).x = proposed_nodeArch.node(i).x;
    %         Temp(inLayer0).y = proposed_nodeArch.node(i).y;
    %         Temp_index(1, inLayer0) = i;
            notLayerZero = notLayerZero + 1;
        else
            nodeArch.node(i).Layer = 0;
        end
    end
    % Temp_xy    : metrix 2xN [loc.x; loc.y] notLayerZero nodes
    % Temp_index : metrix 1XN [node id]

    Model.nodeArch = nodeArch;
end

