%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 250;  % number of nodes 100
Length     = 300;  % network length 300
Width      = 300;  % network width 300
d0       = 87;  % tx distance threshold
% sinkX    = Length / 2;
% sinkY    = Width / 2;
sinkX    = 300;
sinkY    = 150;
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
reselect     = true;
T1 = 87;
T2 = 60;
noOfk = 0;
centr = [];

FND = 1; HND = 1; LND = 1; 
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
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, T1, T2 );
            recluster = false;

%             %%% CH & RN Selection Phase
%             [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch );
        end
    end
    
    
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        p_clusterModel.nodeArch.node(i).type    = 'N'; 
        p_clusterModel.nodeArch.node(i).parent  = [];
        p_clusterModel.nodeArch.node(i).child   = 0;
    end
    %%% CH & RN Selection Phase
    [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch );
    
%     if reselect == true
%     	%%% CH & RN Selection Phase
%         [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, noOfk, centr, netArch );
% %         reselect = false;
%     end
%    

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
    p_clusterModel.nodeArch.avgEnergy = avgEnergy; % averagy
%     p_clusterModel.clusterNode.avgEnergyCluster = avgEnergyCluster; % averagy
    %%% plot STATISTICS
    par_proposed = plotResults(p_clusterModel, r, par_proposed);
    
    %%% plot network deployment (first round)
    if r == 1
        plot_kmeans
    end
    
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
        plot_kmeans
    end  
    if (p_clusterModel.nodeArch.numDead == init_nodeArch.numNode) && LND
        p_clusterModel.LND = r;
        fprintf('[Proposed] ***LND*** round = %d.\n', r);
        LND = 0;
        break
    end    
end% for







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
k = 4;% no. of GH
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
plot_hhca


%%
createfigure(1:p_clusterModel.LND,1:clusterModel.LND,1:h_clusterModel.LND,... % round
             par_proposed.energy, par_leach.energy, par_hhca.energy,... % 
             par_proposed.numDead, par_leach.numDead, par_hhca.numDead,...
             par_proposed.packetToBS, par_leach.packetToBS, par_hhca.packetToBS);

