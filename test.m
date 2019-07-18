%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 300;  % number of nodes 100
Length     = 300;  % network length 300
Width      = 300;  % network width 300
d0         = 87;  % tx distance threshold
sinkX    = 150;
sinkY    = 300;
d_th = 87;
initEnergy  = 0.5;

transEnergy = 50*    0.000000001;
recEnergy   = 50*    0.000000001;
fsEnergy    = 10*    0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*     0.000000001;
packetLength    = 6400;
ctrPacketLength = 200;
r       = 99999;


netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(r, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.netArch   = netArch;
p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch.init_numNodes = numNodes;
par_proposed = struct;
recluster    = true;
reselect     = true;
T1 = 100;
T2 = 87;
noOfk = 0;
centr = [];

FND_flag = 1; HND_flag = 1; LND_flag = 1; 
HND9 =1;

for r = 1:roundArch.numRound  
    p_clusterModel.r = r;
    Temp_xy = [];
    Temp_index = [];
    notLayerZero = 0;
    cluster = [];
%     centr = [];
    centr_node = [];
    
    % first time or recluster
    if recluster == true
        p_clusterModel.numCluster = 0;
        p_clusterModel.clusterNode.no = [];
        p_clusterModel.clusterNode.CID = [];
        p_clusterModel.clusterNode.loc = [];
        p_clusterModel.clusterNode.distance = [];   
        p_clusterModel.clusterNode.countCHs = 0;

        locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
        % reset
        for i = locAlive
            p_clusterModel.nodeArch.node(i).type    = 'N';                
            p_clusterModel.nodeArch.node(i).parent  = [];
            p_clusterModel.nodeArch.node(i).CID     = [];
            p_clusterModel.nodeArch.node(i).child   = 0;
        end
        %%% Network Dimension Phase
        [ p_clusterModel, Temp_xy, Temp_index, notLayerZero ] = NetworkDimension( p_clusterModel, d_th, netArch );
        if ~isempty(Temp_xy) && size(Temp_xy,2)>1
            %%% Clustering Phase
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2 );
        end
        recluster = false;
    end % if recluster
    
%     plot_kmeans
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        p_clusterModel.nodeArch.node(i).type    = 'N'; 
        p_clusterModel.nodeArch.node(i).parent  = [];
        p_clusterModel.nodeArch.node(i).child   = 0;
    end
    %%% CH & RN Selection Phase
    [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch );

    %%% Transmission Phase
    p_clusterModel = dissEnergyCM(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyRN(p_clusterModel, roundArch, netArch);

    
    % check new dead node
    locAlive = find(~p_clusterModel.nodeArch.dead);

    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 

            recluster = true; % have to exec new clustering phase 
        end
    end

    
    % no of alive node
    numAlive = length(locAlive);
    
    % avg energy of network
    avgEnergy = 0;
    for i = locAlive
        avgEnergy = avgEnergy + p_clusterModel.nodeArch.node(i).energy;
    end
    avgEnergy = avgEnergy / length(locAlive);
    
    %%% STATISTICS
    p_clusterModel.nodeArch.numDead = sum(p_clusterModel.nodeArch.dead);
    p_clusterModel.nodeArch.numNode = numAlive; % number of Alive nodes
    p_clusterModel.nodeArch.numAlive = numAlive; % number of Alive nodes
    p_clusterModel.nodeArch.avgEnergy = avgEnergy; % averagy
%     p_clusterModel.clusterNode.avgEnergyCluster = avgEnergyCluster; % averagy
    %%% plot STATISTICS
    par_proposed = plotResults(p_clusterModel, r, par_proposed, roundArch);
    
    %%% plot network deployment (first round)
    if r == 1
        plot_kmeans
    end
    
    %%% FND and HND and LND 
    if p_clusterModel.nodeArch.numDead > 0 && FND_flag
        fprintf('[Proposed] ***FND*** round = %d.\n', r);
        p_clusterModel.FND = r;
        FND_flag = 0;
        plot_kmeans
%         deadId = find(p_clusterModel.nodeArch.dead);
%         fprintf('DEAD loc = [ %f, %f ].\nid = %d\ntype = %s\n', ...
%              p_clusterModel.nodeArch.node(deadId).x, p_clusterModel.nodeArch.node(deadId).y, deadId, p_clusterModel.nodeArch.node(deadId).type);
    end
    if (p_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag
        p_clusterModel.HND = r;
        fprintf('[Proposed] ***HND*** round = %d.\n', r);
        HND_flag = 0;
        plot_kmeans
    end  
    if (p_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND_flag
        p_clusterModel.LND = r;
        fprintf('[Proposed] ***LND*** round = %d.\n', r);
        LND_flag = 0;
        break
    end    
end% for