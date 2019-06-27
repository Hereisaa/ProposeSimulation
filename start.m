%% Main
clc, clear all, close all
%% Parameter
numNodes   = 300;  % number of nodes
Length     = 300;  % network length
Width      = 300;  % network width
sinkX    = Length / 2;
sinkY    = Width / 2;
initEnergy  = 0.5;
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
round       = 99999;
packetLength    = 6400;
ctrPacketLength = 200;
p        = 0.1; % ratio of number of CH (default)
d0       = 87;  % tx distance threshold
T1       = 100; % canopy threshold
T2       = 87;  % canopy threshold


netArch       = newNetwork(Length, Width, sinkX, sinkY...
                           , initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
                % (Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy)
roundArch     = newRound(round, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);
nodeArch      = init_nodeArch; % node's arch for LEACH
p_nodeArch = init_nodeArch; % node's arch for Proposed



%% Proposed method

%%%%%%% Layer Phase %%%%%%%
notLayerZero = 1; % no of nodes that are not in Layer 0.
d_th = d0;
% Temp : all nodes \ {nodes in Layer 0}
% Layer marking using threshold d_th for each layer
for i = 1:p_nodeArch.numNode
    dist = calDistance(p_nodeArch.node(i).x, p_nodeArch.node(i).y, netArch.Sink.x, netArch.Sink.y);
    if( dist > d_th )
        if( dist > 2*d_th )
            p_nodeArch.node(i).Layer = 2;
        else
            p_nodeArch.node(i).Layer = 1;
        end
        Temp_xy(1, notLayerZero) = p_nodeArch.node(i).x;
        Temp_xy(2, notLayerZero) = p_nodeArch.node(i).y;
        Temp_index(1, notLayerZero) = i;
%         Temp(inLayer0).x = proposed_nodeArch.node(i).x;
%         Temp(inLayer0).y = proposed_nodeArch.node(i).y;
%         Temp_index(1, inLayer0) = i;
        notLayerZero = notLayerZero + 1;
    else
        p_nodeArch.node(i).Layer = 0;
    end
end


%%%%%%% Reset (each round)%%%%%%%
for i= 1:p_nodeArch.numNode
    p_nodeArch.node(i).CID = -1;
    p_nodeArch.node(i).child = 0;
end
%%%%%%% Clustering Phase %%%%%%%
% Determine number of k using [Canopy algo].
[ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 );
% plot_canopy

% % Determine number of k using [kOpt].
% % notLayer0 = count;
% % noOfk = round(notLayer0 * p);
% % fprintf('Proposed : number of k = %d.\n',noOfk);

% Clustering using [K-means algo].   
noOfk = length(canopy_centr_node);
[cluster, centr] = usingKmeans(Temp_xy, noOfk, canopy_centr_node);

% mark cluster id
for i = 1:notLayerZero-1
    locNode = [p_nodeArch.node(i).x, p_nodeArch.node(i).y];
    [minToCentr, index] = min(sqrt(sum((repmat(locNode, noOfk, 1) - (centr'))' .^ 2)));
    
    p_nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = which cluster belongs to
end


%%%%%%% CH & RN Selection Phase %%%%%%%
locAlive = find(~p_nodeArch.dead);
for i = 1:length(locAlive)
    locNode_alive(i,1) = p_nodeArch.node(locAlive(i)).x;
    locNode_alive(i,2) = p_nodeArch.node(locAlive(i)).y;
end
for i = 1:noOfk
    locNode_centr = [centr(1,i), centr(2,i)];
    [minToCentr, index] = min(sqrt(sum((repmat(locNode_centr, length(locAlive), 1) - locNode_alive)' .^ 2)));
    
    % becomes CH
    p_nodeArch.node(locAlive(index)).type = 'C';

    p_clusterNode.no(i) = locAlive(index);
    p_clusterNode.CID = p_nodeArch.node(locAlive(index)).CID;
    p_clusterNode.loc(i, 1) = p_nodeArch.node(locAlive(index)).x;
    p_clusterNode.loc(i, 2) = p_nodeArch.node(locAlive(index)).y;
    p_clusterNode.distance(i) = sqrt((p_clusterNode.loc(i, 1) - netArch.Sink.x)^2 + (p_clusterNode.loc(i, 2) - netArch.Sink.y)^2);   
    p_clusterNode.countCHs = noOfk;

    % temp
    centr_node(i) = p_nodeArch.node(locAlive(index));
    centr_node_index(i) = locAlive(index);
end

% assign parent
for i = 1:p_nodeArch.numNode
    % Layer 0 -> sink
    if (p_nodeArch.node(i).CID == -1)
        p_nodeArch.node(i).parent = netArch.Sink;
    % CH -> sink
    elseif ( p_nodeArch.node(i).type == 'C' )
        p_nodeArch.node(i).parent = netArch.Sink;
    % CM -> CH
    else
        for j =1:noOfk
            if(p_nodeArch.node(i).CID == centr_node(j).CID)
                p_nodeArch.node(centr_node_index(j)).child = p_nodeArch.node(centr_node_index(j)).child  + 1;
                p_nodeArch.node(i).parent.x = centr_node(j).x;
                p_nodeArch.node(i).parent.y = centr_node(j).y;
            end
        end
    end
end

p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch = p_nodeArch;
p_clusterModel.numCluster = noOfk;
p_clusterModel.clusterNode = p_clusterNode;

plot_kmeans

par = struct;
for round = 1:roundArch.numRound
% for round = 1:500
%     fprintf('[Proposed] round = %d.\n',round);
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.parent = [];
        else
%             p_clusterModel.nodeArch.node(i).type = 'N';
%             p_clusterModel.nodeArch.node(i).parent = [];
        end
    end
    p_clusterModel.nodeArch.numDead = sum(p_clusterModel.nodeArch.dead);

    p_clusterModel = dissEnergyNonCH(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    
%     par = plotResults(p_clusterModel, round, par);
    
%     fprintf('[Proposed] number of DEAD node = %d.\n',p_clusterModel.nodeArch.numDead);
    
    if p_clusterModel.nodeArch.numDead > 0 % nodeArch.numNode
        fprintf('[Proposed without rotation] FND round = %d.\n', round);
        break;
    end
end

MaxSCH = 0;
MaxSRN = 0;









%% LEACH
% par = struct;
FND = 1; HND = 1; AND = 1;
for r = 1:roundArch.numRound
%     fprintf('[LEACH] round = %d.\n',round);

%     locAlive = find(~clusterModel.nodeArch.dead); % find the nodes that are alive
%     for i = locAlive
%         if clusterModel.nodeArch.node(i).energy <= 0
%             clusterModel.nodeArch.node(i).type = 'D';
%             clusterModel.nodeArch.dead(i) = 1;
%         else
% %             nodeArch.node(i).type = 'N';
% %             nodeArch.node(i).parent = [];
%         end
%     end
%     clusterModel.nodeArch.numDead = sum(clusterModel.nodeArch.dead);

    clusterModel = newCluster(netArch, nodeArch, 'leach', r, p);
    clusterModel = dissEnergyNonCH(clusterModel, roundArch, netArch);
    clusterModel = dissEnergyCH(clusterModel, roundArch, netArch);
    nodeArch = clusterModel.nodeArch;
%     par = plotResults(clusterModel, round, par, netArch);
    
    
    if (clusterModel.nodeArch.numDead >= 1) & FND % FND
        fprintf('[LEACH] FND round = %d.\n', r);
        locAlive = find(~clusterModel.nodeArch.dead);
        for i = 1:init_nodeArch.numNode
            if ( clusterModel.nodeArch.node(i).type == 'D' )  
                fprintf('[LEACH] FND node = %f,%f. id =%d\n', clusterModel.nodeArch.node(i).x, clusterModel.nodeArch.node(i).y, i);
            end
        end        
        FND = 0;
        break
    end
    if (clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) & HND % HND
        fprintf('[LEACH] HND round = %d.\n', r);
        HND = 0;
    end
    if (clusterModel.nodeArch.numDead == init_nodeArch.numNode) & AND % AND
        fprintf('[LEACH] AND round = %d.\n', r);
        AND = 0;
        break
    end
end

plot_leach


