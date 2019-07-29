%% MAIN
clc, clear all, close all
%% NETWORK PARAMETER
numNodes   = 300;  % number of nodes 100
Length     = 300;  % network length 300
Width      = 300;  % network width 300
sinkX    = 150;
sinkY    = 300;
initEnergy  = 0.5;
%d0   = 87;  % tx distance threshold
d_th = 87;
r       = 99999; % inf, until WSN is dead
%% ENERGY MODEL PARAMETER
transEnergy = 50*0.000000001;
recEnergy   = 50*0.000000001;
aggrEnergy  =  5*0.000000001;
fsEnergy    = 10*0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
packetLength    = 4000; % 500 Byte
ctrPacketLength = 200;  % 25 Byte

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
p_clusterModel.recluster = true;
reselect     = true;
T1 = 87;
T2 = 60;
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
        if ~isempty(Temp_xy)
            %%% Clustering Phase
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2);
            recluster = false;

%             %%% CH & RN Selection Phase
%             [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch );
        end
    end % if recluster
    
    
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        p_clusterModel.nodeArch.node(i).type    = 'N'; 
        p_clusterModel.nodeArch.node(i).parent  = [];
        p_clusterModel.nodeArch.node(i).child   = 0;
    end
    %%% CH & RN Selection Phase
    [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch );

    %%% Transmission Phase
    p_clusterModel = dissEnergyCM(p_clusterModel, roundArch, netArch, 'proposed');
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch, 'proposed');
    p_clusterModel = dissEnergyRN(p_clusterModel, roundArch, netArch, 'proposed');
    p_clusterModel.recluster = false;

    
    % check new dead node
    locAlive = find(~p_clusterModel.nodeArch.dead);

    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
            if p_clusterModel.nodeArch.node(i).Layer ~=0
                p_clusterModel.recluster = true;
            end
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
%     
%     % avg energy of each cluster
%     avgEnergyCluster = zeros(1, noOfk);
%     for j = 1:noOfk
%         cm = find(p_clusterModel.clusterMember(j,:));
%         alive = find(~p_clusterModel.nodeArch.dead);
%         alive_cm = intersect(cm, alive);
%         if ~isempty(alive_cm)
%             len_cm = length(alive_cm);
%             energy = 0;
%             for k = alive_cm
%                 energy = energy + p_clusterModel.nodeArch.node(k).energy;
%             end
%             energy = energy / len_cm;
%             avgEnergyCluster(j) = energy; 
%         else
%             avgEnergyCluster(j) = 0;
%         end
%     end
%     
%     % check CH and RN energy
%     cn = find(p_clusterModel.clusterNode.no);
%     rn = find(p_clusterModel.relayNode.no);
%     crn = union(cn, rn);
%     if ~isempty(crn)
%         for j = crn
%             crnid = p_clusterModel.nodeArch.node(j).CID;
%             if  p_clusterModel.nodeArch.node(j).energy < avgEnergyCluster(crnid)*0.5
%                 reselect = true; % have to exec new selection phase 
%             end
%         end
%     end

    
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



%% LEACH ROUND LOOP
clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
clusterModel.nodeArch.numAlive = numAliveNode;
p   = 0.05; % ratio of number of CH (default)
FND_flag = 1; HND_flag = 1; LND_flag = 1;
FND = 0; HND = 0; LND = 0;
par_leach = struct;

for r = 1:roundArch.numRound
    
    
    %%% Clustering Phase
    clusterModel = newCluster(netArch, clusterModel.nodeArch, 'leach', r, p, 0);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    %%% Transmission Phase
    clusterModel = dissEnergyCM(clusterModel, roundArch, netArch, 'leach');
    clusterModel = dissEnergyCH(clusterModel, roundArch, netArch, 'leach');
    
    locAlive = find(~clusterModel.nodeArch.dead);
    clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_leach = plotResults(clusterModel, r, par_leach, roundArch);
    
    %%% FND and HND and LND 
    if (clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[LEACH] ***FND*** round = %d.\n', r);
        FND_flag = 0;
        
    end
    if (clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[LEACH] ***HND*** round = %d.\n', r);
        HND_flag = 0;
        
    end
    if (clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND_flag % LND
        LND = r;
        fprintf('[LEACH] ***LND*** round = %d.\n', r);
        LND_flag = 0;
        break
    end
end
clusterModel.FND = FND;
clusterModel.HND = HND;
clusterModel.LND = LND;
% plot_leach


%% TL-LEACH ROUND LOOP
tl_clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
tl_clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
FND_flag = 1; HND_flag = 1; LND_flag = 1;
FND = 0; HND = 0; LND = 0;
par_TLleach = struct;

for r = 1:roundArch.numRound
    
    
    %%% Clustering Phase
    tl_clusterModel = newCluster(netArch, tl_clusterModel.nodeArch, 'TLleach', r, p, 0);

    %%% Transmission Phase
    tl_clusterModel = dissEnergyCM(tl_clusterModel, roundArch, netArch, 'TLleach');
    tl_clusterModel = dissEnergyCH(tl_clusterModel, roundArch, netArch, 'TLleach');
    tl_clusterModel = dissEnergyCv2(tl_clusterModel, roundArch, netArch, 'TLleach');
    
    locAlive = find(~tl_clusterModel.nodeArch.dead);
    tl_clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_TLleach = plotResults(tl_clusterModel, r, par_TLleach, roundArch);
    
    %%% FND and HND and LND 
    if (tl_clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[TL-LEACH] ***FND*** round = %d.\n', r);
        FND_flag = 0;
        plot_TLleach
    end
    if (tl_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[TL-LEACH] ***HND*** round = %d.\n', r);
        HND_flag = 0;
        plot_TLleach
    end
    if (tl_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND_flag % LND
        LND = r;
        fprintf('[TL-LEACH] ***LND*** round = %d.\n', r);
        LND_flag = 0;
        break
    end
end
tl_clusterModel.FND = FND;
tl_clusterModel.HND = HND;
tl_clusterModel.LND = LND;
% plot_TLleach



%% HHCA ROUND LOOP
h_clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
h_clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
k = 4;% no. of GH
FND_flag = 1; HND_flag = 1; LND_flag = 1;
FND = 0; HND = 0; LND = 0;
par_hhca = struct;

for r = 1:roundArch.numRound
    
    %%% Clustering Phase
    h_clusterModel = newCluster(netArch, h_clusterModel.nodeArch, 'hhca', r, p, k);

    %%% Transmission Phase
    h_clusterModel = dissEnergyCM(h_clusterModel, roundArch, netArch, 'hhca');
    h_clusterModel = dissEnergyCH(h_clusterModel, roundArch, netArch, 'hhca');
    h_clusterModel = dissEnergyGH(h_clusterModel, roundArch, netArch, 'hhca');
    
    locAlive = find(~h_clusterModel.nodeArch.dead);
    h_clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_hhca = plotResults(h_clusterModel, r, par_hhca, roundArch);
    
    %%% FND and HND and LND 
    if (h_clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[HHCA] ***FND*** round = %d.\n', r);
        FND_flag = 0;
        plot_hhca
    end
    if (h_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[HHCA] ***HND*** round = %d.\n', r);
        HND_flag = 0;
        plot_hhca
    end
    if (h_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND_flag % LND
        LND = r;
        fprintf('[HHCA] ***LND*** round = %d.\n', r);
        LND_flag = 0;
        break
    end
end
h_clusterModel.FND = FND;
h_clusterModel.HND = HND;
h_clusterModel.LND = LND;
% plot_hhca


%%

createfigure(numNodes,initEnergy,...
             p_clusterModel.LND,        clusterModel.LND,       h_clusterModel.LND,     tl_clusterModel.LND,... % round
             par_proposed.energy,       par_leach.energy,       par_hhca.energy,        par_TLleach.energy,...
             par_proposed.numAlive,     par_leach.numAlive,     par_hhca.numAlive,      par_TLleach.numAlive,...
             p_clusterModel.FND,        p_clusterModel.HND,...
             clusterModel.FND,          clusterModel.HND,...
             h_clusterModel.FND,        h_clusterModel.HND,...
             tl_clusterModel.FND,       tl_clusterModel.HND,...
             par_proposed.packetToBS,   par_leach.packetToBS,   par_hhca.packetToBS,    par_TLleach.packetToBS);

