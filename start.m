%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 100;  % number of nodes 100
Length     = 100;  % network length 300
Width      = 100;  % network width 300
d0       = 87;  % tx distance threshold
% sinkX    = Length / 2;
% sinkY    = Width / 2;
sinkX    = 50;
sinkY    = 175;
d_th = d0;
initEnergy  = 0.5;

transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*0.000000001;
packetLength    = 4000;
ctrPacketLength = 200;
r       = 99999;


netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(r, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch.init_numNodes = numNodes;
par_proposed = struct;
recluster    = true;
T1 = 87;
T2 = 60;

FND = 1; HND = 1; LND = 1;
for r = 1:roundArch.numRound  
    p_clusterModel.r = r;
    Temp_xy = [];
    Temp_index = [];
    notLayerZero = 0;
    cluster = [];
    centr = [];
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
        if ~isempty(Temp_xy)
            %%% Clustering Phase
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2 );
            %%% CH & RN Selection Phase
            [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, noOfk, centr, netArch );
            % [ p_clusterModel, centr_node ] for plot_kmeans
        end
        recluster = false;
    end
    
    %%% Transmission Phase
    p_clusterModel = dissEnergyCM(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyRN(p_clusterModel, roundArch, netArch);

    %%% Checking if there is a new dead node
    locAlive = find(~p_clusterModel.nodeArch.dead); % alive node's index
    numAlive = length(locAlive);
    
    % avgEnergy
    avgEnergy = 0;
    for i = locAlive
        avgEnergy = avgEnergy + p_clusterModel.nodeArch.node(i).energy;
    end
    avgEnergy = avgEnergy / length(locAlive);
    
    % check dead node
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
            
            recluster = true; % have to exec new clustering phase 
%         elseif p_clusterModel.nodeArch.node(i).energy < avgEnergy &&... % If CH.energy < avgEnergy, recluster.
%                p_clusterModel.nodeArch.node(i).type == 'C'
%            
%             recluster = true;% have to exec new clustering phase 
        end
    end
    
    p_clusterModel.nodeArch.numDead = sum(p_clusterModel.nodeArch.dead);
    p_clusterModel.nodeArch.numNode = numAlive; % number of Alive nodes
    p_clusterModel.nodeArch.avgEnergy = avgEnergy; % averagy
    
    %%% plot result
    par_proposed = plotResults(p_clusterModel, r, par_proposed);
    
    %%% FND and HND and LND 
    if p_clusterModel.nodeArch.numDead > 0 && FND
        fprintf('[Proposed] ***FND*** round = %d.\n', r);
        p_clusterModel.FND = r;
        FND = 0;
%         plot_kmeans
%         deadId = find(p_clusterModel.nodeArch.dead);
%         fprintf('DEAD loc = [ %f, %f ].\nid = %d\ntype = %s\n', ...
%              p_clusterModel.nodeArch.node(deadId).x, p_clusterModel.nodeArch.node(deadId).y, deadId, p_clusterModel.nodeArch.node(deadId).type);
    end
    if (p_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND
        p_clusterModel.HND = r;
        fprintf('[Proposed] ***HND*** round = %d.\n', r);
        HND = 0;
%         plot_kmeans
    end
    if (p_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND
        p_clusterModel.LND = r;
        fprintf('[Proposed] ***LND*** round = %d.\n', r);
        LND = 0;
        break
    end    
end% for

% plot_kmeans





%% LEACH ROUND LOOP
clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
FND = 1; HND = 1; LND = 1;

par_leach = struct;

for r = 1:roundArch.numRound
    %%% Clustering Phase
    clusterModel = newCluster(netArch, clusterModel.nodeArch, 'leach', r, p, 0);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    %%% Transmission Phase
    clusterModel = dissEnergyCM(clusterModel, roundArch, netArch);
    clusterModel = dissEnergyCH(clusterModel, roundArch, netArch);
    
    %%% plot result
    par_leach = plotResults(clusterModel, r, par_leach);
    
    %%% FND and HND and LND 
    if (clusterModel.nodeArch.numDead >= 1) && FND % FND
        clusterModel.FND = r;
        fprintf('[LEACH] ***FND*** round = %d.\n', r);
        FND = 0;
    end
    if (clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND % HND
        clusterModel.HND = r;
        fprintf('[LEACH] ***HND*** round = %d.\n', r);
        HND = 0;
    end
    if (clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND % LND
        clusterModel.LND = r;
        fprintf('[LEACH] ***LND*** round = %d.\n', r);
        LND = 0;
        break
    end
end
% plot_leach



%% HHCA ROUND LOOP
h_clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
h_clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
k = 2;% no. of GH
FND = 1; HND = 1; LND = 1;

par_hhca = struct;

for r = 1:roundArch.numRound
    
    %%% Clustering Phase
    h_clusterModel = newCluster(netArch, h_clusterModel.nodeArch, 'hhca', r, p, k);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    %%% Transmission Phase
    h_clusterModel = dissEnergyCM(h_clusterModel, roundArch, netArch);
    h_clusterModel = dissEnergyCH(h_clusterModel, roundArch, netArch);
    h_clusterModel = dissEnergyGH(h_clusterModel, roundArch, netArch);
    
    %%% plot result
    par_hhca = plotResults(h_clusterModel, r, par_hhca);
    
    %%% FND and HND and LND 
    if (h_clusterModel.nodeArch.numDead >= 1) && FND % FND
        h_clusterModel.FND = r;
        fprintf('[HHCA] ***FND*** round = %d.\n', r);
        FND = 0;
        plot_hhca
    end
    if (h_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND % HND
        h_clusterModel.HND = r;
        fprintf('[HHCA] ***HND*** round = %d.\n', r);
        HND = 0;
        
    end
    if (h_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND % LND
        h_clusterModel.LND = r;
        fprintf('[HHCA] ***LND*** round = %d.\n', r);
        LND = 0;
        break
    end
end
% plot_hhca


%%
createfigure(1:p_clusterModel.LND,1:clusterModel.LND,1:h_clusterModel.LND,...
             par_proposed.energy, par_leach.energy, par_hhca.energy,...
             par_proposed.numDead, par_leach.numDead, par_hhca.numDead,...
             par_proposed.packetToBS, par_leach.packetToBS, par_hhca.packetToBS);

