function [nodeArch, clusterNode, numCluster] = leach(clusterModel, clusterFunParam)
% Create the new node architecture using leach algorithm in beginning of each round. 
% This function is called by newCluster.m
%   Input:
%       clusterModel        Cluster model by newCluster function
%       clusterFunParam     Parameters for the cluster function
%   Example:
%       [nodeArch, clusterNode] = feval('leach', clusterModel, clusterFunParam);
    
    nodeArch = clusterModel.nodeArch;
    netArch  = clusterModel.netArch;
    numCluster = clusterModel.numCluster;

    r = clusterFunParam(1); % round no
    p = clusterModel.p;
    N = nodeArch.numNode; % number of nodes
    
    %%%%%%%% reset the CH after numCluster round
    locAlive = find(~nodeArch.dead); % find the nodes that are alive
    if (mod(r, round(1/p)) == 0)
        for i = locAlive
            nodeArch.node(i).G = 0; % not selected for CH
        end
    end

    for i = 1:nodeArch.numNode
        nodeArch.node(i).child = 0;
    end
    
    
    %%%%%%%% Checking if there is a dead node
    locAlive = find(~nodeArch.dead); % find the nodes that are alive
    for i = locAlive
        if nodeArch.node(i).energy <= 0
            nodeArch.node(i).type = 'D';
            nodeArch.dead(i) = 1;
            nodeArch.node(i).parent = [];
        else
            nodeArch.node(i).type = 'N';
            nodeArch.node(i).parent = [];
        end
    end
 
    nodeArch.numDead = sum(nodeArch.dead);
    
    
    %%%%%%%% find the cluster head
    % define cluster structure
    clusterNode     = struct();
    
    locAlive = find(~nodeArch.dead);
    countCHs = 0;
    % CH selection
    for i = locAlive % search in alive nodes
        temp_rand = rand;
        if (nodeArch.node(i).G <= 0) && ...
           (temp_rand <= leachProbability(r, p)) && ...
           (nodeArch.node(i).energy > 0)

            countCHs = countCHs+1;

            nodeArch.node(i).type        = 'C';
            nodeArch.node(i).parent      = netArch.Sink;
%             nodeArch.node(1,1).G       = round(1/p)-1;
            nodeArch.node(i).G           = 1;
            clusterNode.no(countCHs)     = i; % the no of node
            xLoc = nodeArch.node(i).x; % x location of CH
            yLoc = nodeArch.node(i).y; % y location of CH
            clusterNode.loc(countCHs, 1) = xLoc;
            clusterNode.loc(countCHs, 2) = yLoc;
            % Calculate distance of CH from BS
            clusterNode.distance(countCHs) = sqrt((xLoc - netArch.Sink.x)^2 + ...
                                                  (yLoc - netArch.Sink.y)^2);            
        end 
    end 

    clusterNode.countCHs = countCHs;
    
    
    
    % CM select parent
    for i = locAlive
        if ( nodeArch.node(i).type == 'N' )
            if ( countCHs ~= 0 )
                locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
                [minDis, loc] = min(sqrt(sum((repmat(locNode, countCHs, 1) - clusterNode.loc)' .^ 2)));
                minDisCH =  clusterNode.no(loc);
                nodeArch.node(i).parent = nodeArch.node(minDisCH);
                nodeArch.node(minDisCH).child = nodeArch.node(minDisCH).child + 1;
            else
                nodeArch.node(i).parent.x = netArch.Sink.x;
                nodeArch.node(i).parent.y = netArch.Sink.y;
            end
        else
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
        end
    end
%     countCHs
%     numCluster = numCluster + countCHs;
    numCluster = countCHs;
    
%     fprintf('[LEACH] number of CH (countCHs) = %d\n',countCHs);
%     fprintf('[LEACH] number of total CH (numCluster) = %d\n',numCluster);
end