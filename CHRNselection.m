function [ Model, centr_node ] = CHRNselection( Model, locAlive, noOfk, centr, netArch )
% ClusterHead and RelayNode selection phase
    maxSCH = zeros(1, noOfk);
    maxSRN = zeros(1, noOfk);
    nodeArch = Model.nodeArch;
    
    locAlive_loc = zeros(length(locAlive), 2);
    for i = 1:length(locAlive)
        locAlive_loc(i,1) = nodeArch.node(locAlive(i)).x;
        locAlive_loc(i,2) = nodeArch.node(locAlive(i)).y;
    end

    % which node is nearest to centr becomes CH
    % centr_node = zeros(1,noOfk);
    centr_node_index = zeros(1,noOfk);
    for i = 1:noOfk
        centr_loc = [centr(1,i), centr(2,i)];
        [minToCentr, index] = min(sqrt(sum((repmat(centr_loc, length(locAlive), 1) - locAlive_loc)' .^ 2)));

        % becomes CH
        nodeArch.node(locAlive(index)).type = 'C';

        clusterNode.no(i) = locAlive(index);
        clusterNode.CID(i) = nodeArch.node(locAlive(index)).CID;
        clusterNode.loc(i, 1) = nodeArch.node(locAlive(index)).x;
        clusterNode.loc(i, 2) = nodeArch.node(locAlive(index)).y;
        clusterNode.distance(i) = sqrt((clusterNode.loc(i, 1) - netArch.Sink.x)^2 + (clusterNode.loc(i, 2) - netArch.Sink.y)^2);   
        clusterNode.countCHs = noOfk;

        % temp
        centr_node(i) = nodeArch.node(locAlive(index));
        centr_node_index(i) = locAlive(index);
    end

    % assign each node's parent
    for i = locAlive
        % Layer 0 -> sink
        if (nodeArch.node(i).Layer == 0)
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
        % CH -> sink
        elseif ( nodeArch.node(i).type == 'C' )
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
        % CM -> CH
        else
            nodeArch.node(i).parent.x = clusterNode.loc(nodeArch.node(i).CID, 1);
            nodeArch.node(i).parent.y = clusterNode.loc(nodeArch.node(i).CID, 2);
            nodeArch.node(clusterNode.no(nodeArch.node(i).CID)).child = nodeArch.node(clusterNode.no(nodeArch.node(i).CID)).child  + 1;
%             for j =1:noOfk
%                 if(nodeArch.node(i).CID == clusterNode.CID(j)) % in the same cluster
%                     nodeArch.node(clusterNode.no(j)).child = nodeArch.node(clusterNode.no(j)).child  + 1;
%                     nodeArch.node(i).parent.x = clusterNode.loc(j, 1);
%                     nodeArch.node(i).parent.y = clusterNode.loc(j, 2);
%                 end
%             end
        end
    end

    Model.clusterNode = clusterNode;
    Model.nodeArch = nodeArch;
end

