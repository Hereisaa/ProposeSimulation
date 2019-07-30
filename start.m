%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 100;  % number of nodes 100
Length     = 300;  % network length 300
Width      = 300;  % network width 300
d_th = 87;         % Network Dimension threshold
% sinkX    = Length / 2;
% sinkY    = Width / 2;
sinkX    = 150;
sinkY    = 350;
initEnergy  = 0.5;
transEnergy = 50*    0.000000001;
recEnergy   = 50*    0.000000001;
fsEnergy    = 10*    0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*     0.000000001;
packetLength    = 4000;
ctrPacketLength = 64;
r       = 99999;
simulationTime = 20;


for m = 1:simulationTime
netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(99999, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.netArch   = netArch;
p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch.init_numNodes = numNodes;
% par_proposed = struct;
p_clusterModel.recluster=true;
recluster    = true;
reselect     = true;
T1 = 87;
T2 = 60;
noOfk = 0;
centr = [];
FND = 0; HND = 0; LND = 0;
FND_flag = 1; HND_flag = 1; LND_flag = 1; 

par_proposed = struct;
for r = 1:roundArch.numRound  
    p_clusterModel.r = r;
    Temp_xy = [];
    Temp_index = [];
    notLayerZero = 0;
    cluster = [];
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

    
    %%%control 
    p_clusterModel = dissEnergyCtl(p_clusterModel, roundArch, netArch, 'proposed');
    p_clusterModel.recluster=false;

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
            p_clusterModel.recluster=true;
        end
    end

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
            p_clusterModel.recluster=true;
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
    
    
    %%% FND and HND and LND 
    if p_clusterModel.nodeArch.numDead > 0 && FND_flag
        fprintf('[Proposed] ***FND*** round = %d.\n', r);
        FND = r;
        FND_flag = 0;
%         plot_kmeans
    end
    if (p_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag
        HND = r;
        fprintf('[Proposed] ***HND*** round = %d.\n', r);
        HND_flag = 0;
%         plot_kmeans
    end  
    if (p_clusterModel.nodeArch.numDead >= init_nodeArch.numNode)
        LND = r;
        fprintf('[Proposed] ***LND*** round = %d.\n', r);
        break
    end  
end% for
p_clusterModel.FND = FND;
p_clusterModel.HND = HND;
p_clusterModel.LND = LND;
xpar_proposed(m).FND = FND;
xpar_proposed(m).HND = HND;
xpar_proposed(m).LND = LND;


%% LEACH ROUND LOOP
clear clusterModel
clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
clusterModel.nodeArch.init_numNodes = numNodes;
% numAliveNode = numNodes;
clusterModel.nodeArch.numAlive = numNodes;
p   = 0.05; % ratio of number of CH (default)
FND_flag = 1; HND_flag = 1; LND_flag = 1;
FND = 0; HND = 0; LND = 0;

par_leach = struct;
for r = 1:roundArch.numRound
    
    
    %%% Clustering Phase
    clusterModel = newCluster(netArch, clusterModel.nodeArch, 'leach', r, p, 0);
%     fprintf('[LEACH] number of CH  = %d\n',clusterModel.numCluster);

    clusterModel = dissEnergyCtl(clusterModel, roundArch, netArch, 'leach');
    
    
    %%% Transmission Phase
    clusterModel = dissEnergyCM(clusterModel, roundArch, netArch);
    clusterModel = dissEnergyCHL(clusterModel, roundArch, netArch);
    
    % check new dead node
    locAlive = find(~clusterModel.nodeArch.dead);
    for i = locAlive
        if clusterModel.nodeArch.node(i).energy <= 0
            clusterModel.nodeArch.node(i).type = 'D';
            clusterModel.nodeArch.dead(i) = 1;
            clusterModel.nodeArch.node(i).parent = []; 
            clusterModel.nodeArch.node(i).CID = []; 
            clusterModel.nodeArch.node(i).child = 0; 
        end
    end
    
%     locAlive = find(~clusterModel.nodeArch.dead);
    clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_leach = plotResults(clusterModel, r, par_leach, roundArch);
    
    %%% FND and HND and LND 
    if (clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[LEACH] ***FND*** round = %d.\n', r);
        FND_flag = 0;
%         plot_leach
    end
    if (clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[LEACH] ***HND*** round = %d.\n', r);
        HND_flag = 0;
%         plot_leach
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
xpar_leach(m).FND = FND;
xpar_leach(m).HND = HND;
xpar_leach(m).LND = LND;
% plot_leach


%% TL-LEACH ROUND LOOP
tl_clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
tl_clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
FND_flag = 1; HND_flag = 1; LND_flag = 1; TT_flag = 1;
FND = 0; HND = 0; LND = 0;

par_TLleach = struct;
for r = 1:roundArch.numRound
    
    
    %%% Clustering Phase
    tl_clusterModel = newCluster(netArch, tl_clusterModel.nodeArch, 'TLleach', r, p, 0);

    tl_clusterModel = dissEnergyCtl(tl_clusterModel, roundArch, netArch, 'TLleach');
    
    %%% Transmission Phase
    tl_clusterModel = dissEnergyCM(tl_clusterModel, roundArch, netArch);
    tl_clusterModel = dissEnergyCH(tl_clusterModel, roundArch, netArch);
    tl_clusterModel = dissEnergyCv2(tl_clusterModel, roundArch, netArch);
    
    % check new dead node
    locAlive = find(~tl_clusterModel.nodeArch.dead);
    for i = locAlive
        if tl_clusterModel.nodeArch.node(i).energy <= 0
            tl_clusterModel.nodeArch.node(i).type = 'D';
            tl_clusterModel.nodeArch.dead(i) = 1;
            tl_clusterModel.nodeArch.node(i).parent = []; 
            tl_clusterModel.nodeArch.node(i).CID = []; 
            tl_clusterModel.nodeArch.node(i).child = 0; 
        end
    end
    
%     locAlive = find(~tl_clusterModel.nodeArch.dead);
    tl_clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_TLleach = plotResults(tl_clusterModel, r, par_TLleach, roundArch);
    
    %%% FND and HND and LND 
    if (tl_clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[TL-LEACH] ***FND*** round = %d.\n', r);
        FND_flag = 0;
%         plot_TLleach
    end
    if (tl_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[TL-LEACH] ***HND*** round = %d.\n', r);
        HND_flag = 0;
%         plot_TLleach
    end
%     if (tl_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode*0.85)) && TT_flag % HND
%         HND = r;
%         fprintf('[TL-LEACH] ***85*** round = %d.\n', r);
%         TT_flag = 0;
% %         plot_TLleach
%     end
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
xpar_TLleach(m).FND = FND;
xpar_TLleach(m).HND = HND;
xpar_TLleach(m).LND = LND;
% plot_TLleach



%% HHCA ROUND LOOP

h_clusterModel.nodeArch   = init_nodeArch; % node's arch for LEACH
h_clusterModel.nodeArch.init_numNodes = numNodes;
numAliveNode = numNodes;
p   = 0.05; % ratio of number of CH (default)
k = 2;% no. of GH
FND_flag = 1; HND_flag = 1; LND_flag = 1;
FND = 0; HND = 0; LND = 0;

par_hhca = struct;
for r = 1:roundArch.numRound
    
    %%% Clustering Phase
    h_clusterModel = newCluster(netArch, h_clusterModel.nodeArch, 'hhca', r, p, k);

    h_clusterModel = dissEnergyCtl(h_clusterModel, roundArch, netArch, 'hhca');
    
    % check new dead node
    locAlive = find(~h_clusterModel.nodeArch.dead);
    for i = locAlive
        if h_clusterModel.nodeArch.node(i).energy <= 0
            h_clusterModel.nodeArch.node(i).type = 'D';
            h_clusterModel.nodeArch.dead(i) = 1;
            h_clusterModel.nodeArch.node(i).parent = []; 
            h_clusterModel.nodeArch.node(i).CID = []; 
            h_clusterModel.nodeArch.node(i).child = 0; 
        end
    end
    
    %%% Transmission Phase
    h_clusterModel = dissEnergyCM(h_clusterModel, roundArch, netArch);
    h_clusterModel = dissEnergyCH(h_clusterModel, roundArch, netArch);
    h_clusterModel = dissEnergyGH(h_clusterModel, roundArch, netArch);
    
    locAlive = find(~h_clusterModel.nodeArch.dead);
    h_clusterModel.nodeArch.numAlive = length(locAlive);
    
    %%% plot result
    par_hhca = plotResults(h_clusterModel, r, par_hhca, roundArch);
    
    %%% FND and HND and LND 
    if (h_clusterModel.nodeArch.numDead >= 1) && FND_flag % FND
        FND = r;
        fprintf('[HHCA] ***FND*** round = %d.\n', r);
        FND_flag = 0;
%         plot_hhca
    end
    if (h_clusterModel.nodeArch.numDead >= (init_nodeArch.numNode / 2)) && HND_flag % HND
        HND = r;
        fprintf('[HHCA] ***HND*** round = %d.\n', r);
        HND_flag = 0;
%         plot_hhca
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
xpar_hhca(m).FND = FND;
xpar_hhca(m).HND = HND;
xpar_hhca(m).LND = LND;
% plot_hhca


end



%% STATISTICS
p_FND = 0; l_FND = 0; tl_FND = 0; h_FND = 0;
p_HND = 0; l_HND = 0; tl_HND = 0; h_HND = 0;
p_LND = 0; l_LND = 0; tl_LND = 0; h_LND = 0;

for i = 1:simulationTime
    p_FND = p_FND + xpar_proposed(i).FND;
    l_FND = l_FND + xpar_leach(i).FND;
    tl_FND = tl_FND + xpar_TLleach(i).FND;
    h_FND = h_FND + xpar_hhca(i).FND;
    
    p_HND = p_HND + xpar_proposed(i).HND;
    l_HND = l_HND + xpar_leach(i).HND;
    tl_HND = tl_HND + xpar_TLleach(i).HND;
    h_HND = h_HND + xpar_hhca(i).HND;
end

p_FND = p_FND / simulationTime;
l_FND = l_FND / simulationTime;
tl_FND = tl_FND / simulationTime;
h_FND = h_FND / simulationTime;
    
p_HND = p_HND / simulationTime;
l_HND = l_HND / simulationTime;
tl_HND = tl_HND / simulationTime;
h_HND = h_HND / simulationTime;


createfigure(numNodes,initEnergy,...
             p_clusterModel.LND,        clusterModel.LND,       h_clusterModel.LND,     tl_clusterModel.LND,... % round
             par_proposed.energy,       par_leach.energy,       par_hhca.energy,        par_TLleach.energy,...
             par_proposed.numAlive,     par_leach.numAlive,     par_hhca.numAlive,      par_TLleach.numAlive,...
             p_clusterModel.FND,        p_clusterModel.HND,...
             clusterModel.FND,          clusterModel.HND,...
             h_clusterModel.FND,        h_clusterModel.HND,...
             tl_clusterModel.FND,       tl_clusterModel.HND,...
             par_proposed.packetToBS,   par_leach.packetToBS,   par_hhca.packetToBS,    par_TLleach.packetToBS);
         
         

