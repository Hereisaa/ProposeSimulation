function [nodeArch, clusterNode, gridNode, numCluster, numGrid] = hhca(clusterModel, clusterFunParam, k)
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
    gridNode = struct;

    r = clusterFunParam(1); % round no
    p = clusterModel.p;
    noOfk = k;
    numOfGrid = 0;
    N = nodeArch.numNode; % number of nodes
    
    %%%%%%%% reset the CH after numCluster round
    if (mod(r, round(1/p)) == 0)
        for i = 1:N
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
            nodeArch.node(i).child = 0;
        end
    end
    
    nodeArch.numDead = sum(nodeArch.dead);
   
    
    %%%%%%%% find the cluster head
    % define cluster structure
    clusterNode     = struct();
    
    
    
    %%% Fcm
    fcm_flag = false;
    locAlive = find(~nodeArch.dead);
    P = zeros(2,length(locAlive));
    for i = 1:length(locAlive)
       P(:,i) = [nodeArch.node(i).x; nodeArch.node(i).y]; 
    end
    % using fcm algo
    if( noOfk < length(locAlive) )
        numOfGrid = noOfk;
        E_avg = zeros(noOfk,1);
        fcm_flag = true;
%         [ cluster, centr ] = usingFcm( P, noOfk );
        [centr,U,obj_fcn] = usingFcm(P', noOfk);

        locAlive_loc = zeros(length(locAlive), 2);
        for i = 1:length(locAlive)
            locAlive_loc(i,1) = nodeArch.node(locAlive(i)).x;
            locAlive_loc(i,2) = nodeArch.node(locAlive(i)).y;
        end
        
        for i = 1:length(locAlive)
            lloc = [nodeArch.node(locAlive(i)).x, nodeArch.node(locAlive(i)).y];
%             centr_xy = [centr(1,i), centr(2,i)];
            [minToCentr, index] = min(sqrt(sum((repmat(lloc, noOfk, 1) - centr)' .^ 2)));
            nodeArch.node(i).GID = index;
        end

        centr = centr';
        for i = 1:noOfk   
            for j = 1:length(locAlive)
                locAlive_loc(j,1) = nodeArch.node(locAlive(j)).x;
                locAlive_loc(j,2) = nodeArch.node(locAlive(j)).y;
            end
        
            %%%%% E_avg
            for k = 1:noOfk
                c = 0;
                energy = 0;
                for j = locAlive
                    if (nodeArch.node(j).energy > 0 && nodeArch.node(j).GID == k) 
                        energy = energy + nodeArch.node(j).energy;
                        c = c + 1;
                    end
                end
                energy = energy / c;
                energy(isnan(energy)==1) = 0;
                E_avg(k) = energy;
            end
            

            
            while 1
                % nearest to centr.
                centr_xy = [centr(1,i), centr(2,i)];
                [minToCentr, index] = min(sqrt(sum((repmat(centr_xy, length(locAlive), 1) - locAlive_loc)' .^ 2)));
                id = locAlive(index);
                if nodeArch.node(id).energy >= E_avg(i)
                    % becomes GH
                    nodeArch.node(id).type = 'G';
                    gridNode.no(i) = id; % the no of node
                    xLoc = nodeArch.node(id).x; % x location of GH
                    yLoc = nodeArch.node(id).y; % y location of GH
                    gridNode.loc(i, 1) = xLoc;
                    gridNode.loc(i, 2) = yLoc;
                    % Calculate distance of GH from BS
                    gridNode.distance(i) = sqrt((xLoc - netArch.Sink.x)^2 + (yLoc - netArch.Sink.y)^2);    
                    break
                else
                    locAlive_loc(index,1) = inf;
                    locAlive_loc(index,2) = inf;
                end
            end
            
            
        end
    end% if
    
    
    %%% leach
    countCHs = 0;
    % CH selection
    for i = locAlive % search in alive nodes
        temp_rand = rand;
        if (nodeArch.node(i).G <= 0) && ...
           (temp_rand <= hhcaProbability(r, p)) && ...
           (nodeArch.node(i).energy > 0) && ...
           (nodeArch.node(i).type ~= 'G')

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
            disBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
            if ( countCHs ~= 0 )
                
                locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
                [minDis, loc] = min(sqrt(sum((repmat(locNode, countCHs, 1) - clusterNode.loc)' .^ 2)));
                if minDis < disBS
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
        if ( nodeArch.node(i).type == 'C' )
            if fcm_flag == true % exist GH
                locNode = [nodeArch.node(i).x, nodeArch.node(i).y];
                disBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
                [minDis, loc] = min(sqrt(sum((repmat(locNode, noOfk, 1) - gridNode.loc)' .^ 2)));
                minDisGH =  gridNode.no(loc);
                if minDis < disBS
                    nodeArch.node(i).parent = nodeArch.node(minDisGH);
                    nodeArch.node(minDisGH).child = nodeArch.node(minDisGH).child + 1;
                else
                    nodeArch.node(i).parent.x = netArch.Sink.x;
                    nodeArch.node(i).parent.y = netArch.Sink.y;
                end
            else
                nodeArch.node(i).parent.x = netArch.Sink.x;
                nodeArch.node(i).parent.y = netArch.Sink.y;
            end
        end
        if ( nodeArch.node(i).type == 'G' )
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
        end
    end

    numCluster = countCHs;
    numGrid = numOfGrid;
%     fprintf('[LEACH] number of CH (countCHs) = %d\n',countCHs);
%     fprintf('[LEACH] number of total CH (numCluster) = %d\n',numCluster);
end