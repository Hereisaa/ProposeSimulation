% Main
%% Parameter
clc, clear all, close all

numNodes = 1000; % number of nodes
p = 0.05; % ratio of number of CH (default)
d0 = 87; % distance threshold
netArch  = newNetwork(1000, 1000, 500, 500); % (Network Length, Network  Width, BS_x, BS_y)
init_nodeArch = newNodes(netArch, numNodes);
nodeArch = init_nodeArch; % node's arch for leach
proposed_nodeArch = init_nodeArch; % node's arch for proposed
roundArch = newRound(); 


%% Proposed method
%%%%%%% Initialize %%%%%%%
for i= 1:proposed_nodeArch.numNode
    proposed_nodeArch.node(i).CID = 0;
end

%%%%%%% Layer Phase %%%%%%%
count = 1; % no of nodes that are not in Layer 0.
d = d0;
% Temp : all nodes \ {nodes in Layer 0}

% Layer marking 
for i = 1:proposed_nodeArch.numNode
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

%%%%%%% Clustering Phase %%%%%%%
% Determine number of k using [Canopy algo].
T1 = 100; T2 = 87;
[ k, canopy_centr, canopy_centr_node ] = usingCanopy( Temp_xy, T1, T2 );
plot_canopy

% Determine number of k using [kOpt].
% notLayer0 = count;
% noOfk = round(notLayer0 * p);
% fprintf('Proposed : number of k = %d.\n',noOfk);

% using K-means algo.   
noOfk = length(canopy_centr_node);
[cluster, centr] = usingKmeans(Temp_xy, noOfk, canopy_centr_node);
for i = 1:count-1
    proposed_nodeArch.node(Temp_index(1,i)).CID = cluster(i); % CID = cluster id = which cluster belongs to
end

%%%%%%% CH & RN Selection Phase %%%%%%%





plot_kmeans





%% LEACH
% par = struct;
% % for r = 1:roundArch.numRound
% for round = 1:500
%     round
%     clusterModel = newCluster(netArch, nodeArch, 'leach', round, p);
%     clusterModel = dissEnergyCH(clusterModel, roundArch);
%     clusterModel = dissEnergyNonCH(clusterModel, roundArch);
%     nodeArch     = clusterModel.nodeArch; % new node architecture after select CHs
%     
% %     par = plotResults(clusterModel, round, par);
% %     if nodeArch.numDead == nodeArch.numNode
% %         break
% %     end
% end
% 
% % plot_leach


