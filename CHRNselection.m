function [ Model, centr_node ] = CHRNselection( Model, locAlive, noOfk, centr, netArch )
% ClusterHead and RelayNode selection phase
    nodeArch = Model.nodeArch;
    relayNode.countRNs = 0;

    X = find(nodeArch.Layer); % nodes that not in Layer 0
    Y = intersect(locAlive, X); % alive and not in Layer 0
    locAlive_loc = zeros(length(Y), 2);
    for i = 1:length(Y)
        locAlive_loc(i,1) = nodeArch.node(Y(i)).x;
        locAlive_loc(i,2) = nodeArch.node(Y(i)).y;
    end

    %%% cal avg. para
    SCH = zeros(1, nodeArch.init_numNodes);
    SRN = zeros(1, nodeArch.init_numNodes);
    maxSCH = zeros(noOfk, 2);
    maxSRN = zeros(noOfk, 2);
    E_avg        = zeros(noOfk, 1);
    d_toCentr    = zeros(noOfk, 1);
    d_toBS       = zeros(noOfk, 1);
    maxToCentr  = zeros(noOfk, 1);
    minToCentr  = zeros(noOfk, 1);
    maxToBS     = zeros(noOfk, 1);
    minToBS     = zeros(noOfk, 1);
    E_max     = zeros(noOfk, 1);
    E_min     = zeros(noOfk, 1);
    for i =1:noOfk
       member           = find(Model.clusterMember(i,:)); 
       noOfMember       = length(member);
       totalEnergy      = 0;
       totalDisToCentr  = 0;
       totalDisToBS     = 0;
       maxDisToCentr  = 0;
       minDisToCentr  = Inf;
       maxDisToBS     = 0;
       minDisToBS     = Inf;
       maxEnergy      = 0;
       minEnergy      = Inf;
       
       for j = 1:noOfMember
           toCentr = calDistance(nodeArch.node(member(j)).x, nodeArch.node(member(j)).y, centr(1,i), centr(2,i));
           toBS = calDistance(nodeArch.node(member(j)).x, nodeArch.node(member(j)).y, netArch.Sink.x, netArch.Sink.y);
           energy = nodeArch.node(member(j)).energy;
           if toCentr > maxDisToCentr
               maxDisToCentr = toCentr;
           end
           if toBS > maxDisToBS
               maxDisToBS = toBS;
           end
           if toCentr < minDisToCentr
               minDisToCentr = toCentr;
           end
           if toBS < minDisToBS
               minDisToBS = toBS;
           end
           
           if energy > maxEnergy
               maxEnergy = energy;
           end
           if energy < minEnergy
               minEnergy = energy;
           end
           
           totalEnergy       = totalEnergy       +   nodeArch.node(member(j)).energy;
           totalDisToCentr	 = totalDisToCentr   +   toCentr;
           totalDisToBS      = totalDisToBS      +   toBS;
       end
       
       E_avg(i,1)       = totalEnergy       / noOfMember;
       d_toCentr(i,1)   = totalDisToCentr   / noOfMember;
       d_toBS(i,1)      = totalDisToBS      / noOfMember;
       maxToCentr(i,1) = maxDisToCentr;
       minToCentr(i,1) = minDisToCentr;
       maxToBS(i,1)    = maxDisToBS;
       minToBS(i,1)    = minDisToBS;
       E_max(i,1)    = maxEnergy;
       E_min(i,1)    = minEnergy;
    end
    
    %%% cal SCH SRN ( without layer 0 )
    for i =1:nodeArch.init_numNodes
        if ~isempty(nodeArch.node(i).CID)
            SCH(i) = 0;
            SRN(i) = 0;
            nCID            = nodeArch.node(i).CID;
            E_res           = nodeArch.node(i).energy;

            d_Centr = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, centr(1,nCID), centr(2,nCID));
            d_BS    = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);

            [ calSCH, calSRN ] = calSelection( E_res, E_avg(nCID,1), E_max(nCID,1), E_min(nCID,1), d_Centr, d_toCentr(nCID,1), d_BS, d_toBS(nCID,1),...
                                    maxToCentr(nCID,1), minToCentr(nCID,1), maxToBS(nCID,1), minToBS(nCID,1));
            
            SCH(i) = calSCH;
            SRN(i) = calSRN;
        else
            SCH(i) = 0;
            SRN(i) = 0;
        end
    end
    
    %%% dead node --> 0
    for i =1:nodeArch.init_numNodes
        if(strcmp(nodeArch.node(i).type,'D') )
            SCH(i) = 0;
            SRN(i) = 0;
        end
    end

    %%% Find maxSCH and maxSRN
    for i =1:noOfk
        cm = find(Model.clusterMember(i,:));     
        if ~isempty(cm)
            [res, indexSCH] = max(SCH(cm));
            indexSCH = cm(indexSCH);
            maxSCH(i,1) = indexSCH(1);
            maxSCH(i,2) = res(1);

            [res, indexSRN] = max(SRN(cm));
            indexSRN = cm(indexSRN);
            maxSRN(i,1) = indexSRN(1);
            maxSRN(i,2) = res(1);
        end
    end
    
    
    % which node is nearest to centr becomes CH
    % centr_node = zeros(1,noOfk);
    centr_node_index = zeros(1,noOfk);
    
    %%% select CH & RN in each cluster
    if noOfk ~= 0
       for i = 1:noOfk   
    %         %%% This section is for just nearest centr node.
    %         centr_xy = [centr(1,i), centr(2,i)];
    %         [minToCentr, index] = min(sqrt(sum((repmat(centr_xy, length(Y), 1) - locAlive_loc)' .^ 2)));
    %         id = Y(index);
            if ~isempty(find(Model.clusterMember(i,:)))
                
                %%% Max SRN %%%
                id = maxSRN(i,1);
                % becomes RN
                nodeArch.node(id).type = 'R';
                % relayNode struct
                relayNode.no(i) = id;
                relayNode.CID(i) = nodeArch.node(id).CID;
                relayNode.loc(i, 1) = nodeArch.node(id).x;
                relayNode.loc(i, 2) = nodeArch.node(id).y;
                relayNode.distance(i) = sqrt((relayNode.loc(i, 1) - netArch.Sink.x)^2 + (relayNode.loc(i, 2) - netArch.Sink.y)^2);   
                relayNode.countRNs = noOfk;

                %%% Max SCH %%%
                id = maxSCH(i,1);
                % becomes CH
                nodeArch.node(id).type = 'C';
                % clusterNode struct
                clusterNode.no(i) = id;

                clusterNode.CID(i) = nodeArch.node(id).CID;
                clusterNode.loc(i, 1) = nodeArch.node(id).x;
                clusterNode.loc(i, 2) = nodeArch.node(id).y;
                clusterNode.distance(i) = sqrt((clusterNode.loc(i, 1) - netArch.Sink.x)^2 + (clusterNode.loc(i, 2) - netArch.Sink.y)^2);   
                clusterNode.countCHs = noOfk;

        %         % temp
        %         centr_node(i) = nodeArch.node(id);
        %         centr_node_index(i) = id;
            end
        end
    end

% % %     % For BS_near
% % %     % Layer 0 and Energy > avgEnergy  ----> 'R'
% % %     c = 0;
% % %     energy = 0;
% % %     for i = locAlive
% % %         if (nodeArch.node(i).Layer == 0)
% % %             energy = energy + nodeArch.node(i).energy;
% % %             c = c + 1;
% % %         end
% % %     end    
% % %     energy = energy / c;
% % %     for i = locAlive
% % %         if (nodeArch.node(i).Layer == 0) 
% % %             if (nodeArch.node(i).energy >= energy)
% % %                 nodeArch.node(i).type = 'R';
% % %                 relayNode.countRNs = relayNode.countRNs + 1;
% % %                 rc = relayNode.countRNs;
% % %                 relayNode.no(rc) = i;
% % %                 relayNode.CID(rc) = -1;
% % %                 relayNode.loc(rc, 1) = nodeArch.node(i).x;
% % %                 relayNode.loc(rc, 2) = nodeArch.node(i).y;
% % %                 relayNode.distance(rc) = sqrt((relayNode.loc(rc, 1) - netArch.Sink.x)^2 + (relayNode.loc(rc, 2) - netArch.Sink.y)^2);
% % %                 
% % %             else
% % %                 nodeArch.node(i).parent.id = 0;
% % %             end
% % %         end
% % %     end 

    
    
    %%
    %%% assign each node's parent
    for i = locAlive
        % Layer = 0 -> sink
        if (nodeArch.node(i).Layer == -1)
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
            nodeArch.node(i).parent.id = 0;
        % Layer != 0 
        else
            % RN -> RN or sink
            if strcmp(nodeArch.node(i).type,'R') 
                relayLayer = nodeArch.node(i).Layer;
                while (1)
                    relayLayer = relayLayer - 1;
                    if ( relayLayer == -1 )
                        nodeArch.node(i).parent.x = netArch.Sink.x;
                        nodeArch.node(i).parent.y = netArch.Sink.y;
                        nodeArch.node(i).parent.id = 0;
                        break
                    else
                        locM = [];
                        indexM = [];
                        L = find(nodeArch.Layer <= relayLayer);
                        D = find(~nodeArch.dead);
                        M = intersect(L,D);
                        M = intersect(M,relayNode.no);
                        
                        if isempty(M)
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                            nodeArch.node(i).parent.id = 0;
                            break
                        end
                        
                        for j = M
                           for k =1:size(relayNode.no,2)
                               if relayNode.no(k) == j && relayNode.no(k)~=i
                                   indexM = [indexM, relayNode.no(k)];
                                   locM = [locM, [relayNode.loc(k,1);relayNode.loc(k,2)]];
                               end
                           end
                        end
                        
                        if isempty(indexM)
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                            nodeArch.node(i).parent.id = 0;
                        end
                        
                        
                        

                        locNode = [nodeArch.node(i).x; nodeArch.node(i).y];
                        [minDist, index] = min(sqrt(sum(( repmat(locNode, 1, length(indexM)) - locM) .^ 2)));
                        id = indexM(index);
                        
                        toRN = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, nodeArch.node(id).x, nodeArch.node(id).y);
                        toBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
                        
                        if toRN < toBS
                            nodeArch.node(i).parent.x = nodeArch.node(id).x;
                            nodeArch.node(i).parent.y = nodeArch.node(id).y; 
                            nodeArch.node(i).parent.id = id;
                            break
                        else
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                            nodeArch.node(i).parent.id = 0;
                        end
                    end            
                end % while
            % CH -> RN
            elseif ( strcmp(nodeArch.node(i).type,'C') )
                CID = nodeArch.node(i).CID;
                relayID = relayNode.no(CID);
                if relayID == i % when CH=RN itself
                    
                        locM = [];
                        indexM = [];
                        relayLayer = nodeArch.node(i).Layer;
                        L = find(nodeArch.Layer <= relayLayer-1);
                        D = find(~nodeArch.dead);
                        M = intersect(L,D);
                        M = intersect(M,relayNode.no);
                        
                        if isempty(M)
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                            nodeArch.node(i).parent.id = 0;
                            continue
                        end
                        
                        for j = M
                           for k =1:size(relayNode.no,2)
                               if relayNode.no(k) == j
                                   indexM = [indexM, relayNode.no(k)];
                                   locM = [locM, [relayNode.loc(k,1);relayNode.loc(k,2)]];
                               end
                           end
                        end

                        locNode = [nodeArch.node(i).x; nodeArch.node(i).y];
                        [minDist, index] = min(sqrt(sum(( repmat(locNode, 1, length(indexM)) - locM) .^ 2)));
                        id = indexM(index);
                        
                        toRN = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, nodeArch.node(id).x, nodeArch.node(id).y);
                        toBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
                        
                        if toRN < toBS
                            nodeArch.node(i).parent.x = nodeArch.node(id).x;
                            nodeArch.node(i).parent.y = nodeArch.node(id).y; 
                            nodeArch.node(i).parent.id = id;
                        else
                            nodeArch.node(i).parent.x = netArch.Sink.x;
                            nodeArch.node(i).parent.y = netArch.Sink.y;
                            nodeArch.node(i).parent.id = 0;
                        end
                else
                    nodeArch.node(i).parent.x = nodeArch.node(relayID).x;
                    nodeArch.node(i).parent.y = nodeArch.node(relayID).y;
                    nodeArch.node(i).parent.id = relayID;
                    nodeArch.node(relayID).CH = i;
                end
            % CM -> CH
            else
                nodeArch.node(i).parent.x = clusterNode.loc(nodeArch.node(i).CID, 1);
                nodeArch.node(i).parent.y = clusterNode.loc(nodeArch.node(i).CID, 2);
                nodeArch.node(i).parent.id = clusterNode.no(nodeArch.node(i).CID);
            end
        end %if
    end %for
    
    
    
    
    for i = locAlive
        if strcmp(nodeArch.node(i).type,'N')
            pid = nodeArch.node(i).parent.id;
            if pid ~=0
                nodeArch.node(pid).child = nodeArch.node(pid).child + 1;
            end
        end
    end
    for i = locAlive
        if strcmp(nodeArch.node(i).type,'C')
            pid = nodeArch.node(i).parent.id;
            if pid ~=0
                nodeArch.node(pid).child = nodeArch.node(pid).child + 1;
            end
        end
    end
    for i = locAlive
        if strcmp(nodeArch.node(i).type,'R')
            pid = nodeArch.node(i).parent.id;
            if pid ~=0
                nodeArch.node(pid).child = nodeArch.node(pid).child + nodeArch.node(i).child;
            end
        end
    end
    
    
    if noOfk ~= 0
        Model.clusterNode = clusterNode;
        Model.relayNode = relayNode;
    end
    
    Model.nodeArch = nodeArch;
end

