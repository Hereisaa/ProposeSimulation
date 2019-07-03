function [ Model, centr_node ] = CHRNselection( Model, locAlive, noOfk, centr, netArch )
% ClusterHead and RelayNode selection phase
    nodeArch = Model.nodeArch;

    X = find(nodeArch.Layer); % nodes that not in Layer 0
    Y = intersect(locAlive, X); % alive and not in Layer 0
    locAlive_loc = zeros(length(Y), 2);
    for i = 1:length(Y)
        locAlive_loc(i,1) = nodeArch.node(Y(i)).x;
        locAlive_loc(i,2) = nodeArch.node(Y(i)).y;
    end

    %%% cal avg. para
    nodeArch.SCH = zeros(1, nodeArch.init_numNodes);
    nodeArch.SRN = zeros(1, nodeArch.init_numNodes);
    E_avg        = zeros(noOfk, 1);
    d_toCentr    = zeros(noOfk, 0);
    d_toBS       = zeros(noOfk, 0);
    for i =1:noOfk
       member           = find(Model.clusterMember(i,:)); 
       noOfMember       = length(member);
       totalEnergy      = 0;
       totalDisToCentr  = 0;
       totalDisToBS     = 0;
       
       for j = 1:noOfMember
          totalEnergy       = totalEnergy       +   nodeArch.node(member(j)).energy;
          totalDisToCentr	= totalDisToCentr   +   calDistance(nodeArch.node(member(j)).x, nodeArch.node(member(j)).y, centr(1,i), centr(2,i));
          totalDisToBS      = totalDisToBS      +   calDistance(nodeArch.node(member(j)).x, nodeArch.node(member(j)).y, netArch.Sink.x, netArch.Sink.y);
       end
       
       E_avg(i,1)       = totalEnergy       / noOfMember;
       d_toCentr(i,1)   = totalDisToCentr   / noOfMember;
       d_toBS(i,1)      = totalDisToBS      / noOfMember;
    end
    
    %%% cal SCH SRN ( without layer 0 )
    for i =1:nodeArch.init_numNodes
        if ~isempty(nodeArch.node(i).CID)
            nodeArch.SCH(i) = 0;
            nodeArch.SCH(i) = 0;
            nCID            = nodeArch.node(i).CID;
            E_res           = nodeArch.node(i).energy;

            d_Centr = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, centr(1,nCID), centr(2,nCID));
            d_BS    = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);

            [ calSCH, calSRN ] = calSelection( E_res, E_avg(nCID,1), d_Centr, d_toCentr(nCID,1), d_BS, d_toBS(nCID,1)  );
            
            nodeArch.SCH(i) = calSCH;
            nodeArch.SRN(i) = calSRN;
        end
    end

    for i =1:noOfk
        cm = find(Model.clusterMember(i,:));
        [SCH, id] = max(nodeArch.SCH(1, cm));
        id = cm(id);
        nodeArch.maxSCH(i,1) = id;
        nodeArch.maxSCH(i,2) = SCH;
        
        
        cm = find(Model.clusterMember(i,:));
        [SRN, id] = max(nodeArch.SRN(1, cm));
        id = cm(id);
        nodeArch.maxSRN(i,1) = id;
        nodeArch.maxSRN(i,2) = SRN;
    end
    
    
    % which node is nearest to centr becomes CH
    % centr_node = zeros(1,noOfk);
    centr_node_index = zeros(1,noOfk);
    for i = 1:noOfk
        
%         %%% This section is for just nearest centr.
%         centr_xy = [centr(1,i), centr(2,i)];
%         [minToCentr, index] = min(sqrt(sum((repmat(centr_xy, length(Y), 1) - locAlive_loc)' .^ 2)));
%         id = Y(index);

        % Max SCH 
        id = nodeArch.maxSCH(i,1);
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
        
        % Max SRN 
        id = nodeArch.maxSRN(i,1);
        % becomes RN
        nodeArch.node(id).type = 'R';
        % relayNode struct
        relayNode.no(i) = id;
        relayNode.CID(i) = nodeArch.node(id).CID;
        relayNode.loc(i, 1) = nodeArch.node(id).x;
        relayNode.loc(i, 2) = nodeArch.node(id).y;
        relayNode.distance(i) = sqrt((relayNode.loc(i, 1) - netArch.Sink.x)^2 + (relayNode.loc(i, 2) - netArch.Sink.y)^2);   
        relayNode.countRNs = noOfk;
    end

    % Layer 0 -> 'R'
    for i = locAlive
        if (nodeArch.node(i).Layer == 0)
            nodeArch.node(i).type = 'R';
        end
    end    
        
    %%% assign each node's parent
    for i = locAlive
        % Layer = 0 -> sink
        if (nodeArch.node(i).Layer == 0)
            nodeArch.node(i).parent.x = netArch.Sink.x;
            nodeArch.node(i).parent.y = netArch.Sink.y;
        % Layer != 0 
        else
            % RN -> RN / sink
            if strcmp(nodeArch.node(i).type,'R') 
                relayLayer = nodeArch.node(i).Layer;
                while (1)
                    relayLayer = relayLayer - 1;
                    if ( relayLayer == -1 )
                        nodeArch.node(i).parent.x = netArch.Sink.x;
                        nodeArch.node(i).parent.y = netArch.Sink.y;
                        break
                    else
                        locM = [];
                        indexM = [];
                        M = find(nodeArch.Layer == relayLayer);
                        
                        for j =M
                           if  (strcmp(nodeArch.node(j).type,'R'))
                               tmp = [nodeArch.node(j).x; nodeArch.node(j).y];
                               locM = [locM,tmp];
                               indexM = [indexM,j];
                           end
                        end
                        
                        if isempty(locM)
                           continue 
                        end
                        
                        locNode = [nodeArch.node(i).x; nodeArch.node(i).y];
                        [minDist, index] = min(sqrt(sum(( repmat(locNode, 1, length(indexM)) - locM) .^ 2)));
                        id = indexM(index);
                        
                        toRN = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, nodeArch.node(id).x, nodeArch.node(id).y);
                        toBS = calDistance(nodeArch.node(i).x, nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
                        
                        if toRN < toBS
                            nodeArch.node(i).parent.x = nodeArch.node(id).x;
                            nodeArch.node(i).parent.y = nodeArch.node(id).y; 
                            nodeArch.node(id).child = nodeArch.node(id).child +  nodeArch.node(i).child;
                            break
                        end
                    end            
                end % while
            % CH -> RN
            elseif ( strcmp(nodeArch.node(i).type,'C') )
                CID = nodeArch.node(i).CID;
                relayID = relayNode.no(CID);
                nodeArch.node(i).parent.x = nodeArch.node(relayID).x;
                nodeArch.node(i).parent.y = nodeArch.node(relayID).y;
                nodeArch.node(relayID).child = nodeArch.node(relayID).child  + 1;
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
        end %if
    end %for

    Model.clusterNode = clusterNode;
    Model.relayNode = relayNode;
    Model.nodeArch = nodeArch;
end

