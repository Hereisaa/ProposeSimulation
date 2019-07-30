function [nodeArch, clusterNode, numCluster] = TLleach(clusterModel, clusterFunParam)
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
    N = nodeArch.init_numNodes; % number of nodes
    
    %%%%%%%% reset the CH after numCluster round
    if (mod(r, round(1/p)) == 0)
        for i = 1:N
            nodeArch.node(i).G = 0; % not selected for CH
        end
    end

    for i = 1:N
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
    % level 1 CH selection
    for i = locAlive % search in alive nodes
        temp_rand = rand;
        if (nodeArch.node(i).G <= 0) && ...
           (temp_rand <= tlleachProbability(r, p)) && ...
           (nodeArch.node(i).energy > 0)
            
            countCHs = countCHs+1;

            nodeArch.node(i).type        = 'C';
            nodeArch.node(i).parent      = netArch.Sink;
%             nodeArch.node(i).parent.x = netArch.Sink.x;
%             nodeArch.node(i).parent.y = netArch.Sink.y;
%             nodeArch.node(1,1).G       = round(1/p)-1;
            nodeArch.node(i).G           = 1;
            clusterNode.no(countCHs)     = i; % the id of node
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
    
    
    
    % level 2 CH selection
    if countCHs > 1
        numCHv2 = ceil(countCHs * p);
    else
        numCHv2 = 0;
    end
    eOfCH = zeros(1,countCHs);
    iOfCH = zeros(1,countCHs);
    % search in CH nodes according to the highest residual energy
    for i = 1:countCHs 
        eOfCH(i) = nodeArch.node(clusterNode.no(i)).energy;
        iOfCH(i) = clusterNode.no(i);
    end 
    [res, index] = sort(eOfCH,'descend');
    
    countCHv2 = 0;
    for i = 1:numCHv2
        countCHv2 = countCHv2 + 1;
        nodeArch.node(iOfCH(index(i))).type  = 'Cv2';
        xLoc = nodeArch.node(iOfCH(index(i))).x; % x location of Cv2
        yLoc = nodeArch.node(iOfCH(index(i))).y; % y location of Cv2
        Cv2Node.loc(countCHv2, 1) = xLoc;
        Cv2Node.loc(countCHv2, 2) = yLoc;
        Cv2Node.no(countCHv2)     = iOfCH(index(i));
        nodeArch.node(iOfCH(index(i))).parent.x = netArch.Sink.x;
        nodeArch.node(iOfCH(index(i))).parent.y = netArch.Sink.y;
    end

    
%     clear clusterNode
%     clusterNode     = struct();
%     counts = 0;
%     for i = locAlive
%         if nodeArch.node(i).type == 'C';
%             counts=counts+1;
%             clusterNode.no(counts)     = i; % the id of node
%             xLoc = nodeArch.node(i).x; % x location of CH
%             yLoc = nodeArch.node(i).y; % y location of CH
%             clusterNode.loc(counts, 1) = xLoc;
%             clusterNode.loc(counts, 2) = yLoc;
%             % Calculate distance of CH from BS
%             clusterNode.distance(counts) = sqrt((xLoc - netArch.Sink.x)^2 + ...
%                                                   (yLoc - netArch.Sink.y)^2); 
%         end
%     end
    clusterNode.countCHs = countCHs;
    clusterNode.countCHv2 = numCHv2;
    
    
    
    % CM select parent sink/C/Cv2
    for i = locAlive
            dtoBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
            if ( countCHs ~= 0 )
                    if ( nodeArch.node(i).type == 'C' )
                       
                        if numCHv2 ~= 0
                            locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
                            [minDis, loc] = min(sqrt(sum((repmat(locNode, countCHv2, 1) - Cv2Node.loc)' .^ 2)));
                            if minDis < dtoBS
                                minDisCv2 =  Cv2Node.no(loc);
                                nodeArch.node(i).parent = nodeArch.node(minDisCv2);
                                nodeArch.node(minDisCv2).child = nodeArch.node(minDisCv2).child + 1;
                            else
                                nodeArch.node(i).parent.x = netArch.Sink.x;
                                nodeArch.node(i).parent.y = netArch.Sink.y;
                            end
                        else
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                        end
                    elseif ( nodeArch.node(i).type == 'N' )
                        locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
                        [minDis, loc] = min(sqrt(sum((repmat(locNode, countCHs, 1) - clusterNode.loc)' .^ 2)));
%                         if minDis < dtoBS
                            minDisCH =  clusterNode.no(loc);
                            nodeArch.node(i).parent = nodeArch.node(minDisCH);
                            nodeArch.node(minDisCH).child = nodeArch.node(minDisCH).child + 1;
%                         else
%                             nodeArch.node(i).parent.x = netArch.Sink.x;
%                             nodeArch.node(i).parent.y = netArch.Sink.y;
%                         end
                    end
            else
                nodeArch.node(i).parent.x = netArch.Sink.x;
                nodeArch.node(i).parent.y = netArch.Sink.y;
            end
    end
%     countCHs
    numCluster = countCHs + countCHv2;
%     fprintf('[LEACH] number of CH (countCHs) = %d\n',countCHs);
%     fprintf('[LEACH] number of total CH (numCluster) = %d\n',numCluster);
end