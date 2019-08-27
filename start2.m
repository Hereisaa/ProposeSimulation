%% MAIN
clc, clear all, close all
%% PARAMETER
numNodes   = 300;  % number of nodes 100
Length     = 300;  % network length 300
Width      = 300;  % network width 300
% TH = [90,80,70,60,50,40,30,20,10]; % a
% dth = [10,20,30,40,50,60,70,80,90]; % b
TH = [90,80,70,60,50,40,30,20,10]; % a
dth = [10,20,30,40,50,60,70,80,90]; % b
sinkX    = 150;
sinkY    = 350;
initEnergy  = 0.5;
E_th = 0.01; % energy threshold
delta = 10; % GPS error
transEnergy = 50*    0.000000001;
recEnergy   = 50*    0.000000001;
fsEnergy    = 10*    0.000000000001;
mpEnergy    = 0.0013*0.000000000001;
aggrEnergy  = 5*     0.000000001;
packetLength    = 4000;
ctrPacketLength = 100;
r       = 99999;
simulationTime = 30;
parameter = strcat(num2str(numNodes) , 'N' , num2str(Length) , 'M' , num2str(initEnergy) , 'J');
tradeOff_FND = zeros(9,9);
tradeOff_HND = zeros(9,9);

for a = 9:9
for b = 1:9

    fprintf('TH = %d, dth = %d.\n', TH(a), dth(b));
    
for m = 1:simulationTime
    m
netArch       = newNetwork(Length, Width, sinkX, sinkY, initEnergy, transEnergy, recEnergy, fsEnergy, mpEnergy, aggrEnergy);
roundArch     = newRound(99999, packetLength, ctrPacketLength);
init_nodeArch = newNodes(netArch, numNodes);

%% PROPOSED ROUND LOOP
clearvars p_clusterModel;
p_clusterModel.nodeArch   = init_nodeArch; % node's arch for Proposed
p_clusterModel.netArch   = netArch;
p_clusterModel.clusterFun = 'proposed';
p_clusterModel.nodeArch.init_numNodes = numNodes;
p_clusterModel.recluster=true;
p_clusterModel.nodeArch.avgEnergy = initEnergy;
recluster    = true;
reselect     = true;

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

        locAlive = find(~p_clusterModel.nodeArch.dead);
        % reset
        for i = locAlive
            p_clusterModel.nodeArch.node(i).type    = 'N';                
            p_clusterModel.nodeArch.node(i).parent  = [];
            p_clusterModel.nodeArch.node(i).CID     = [];
            p_clusterModel.nodeArch.node(i).child   = 0;
        end
        
        %%% Network Dimension Phase
        [ p_clusterModel, Temp_xy, Temp_index, notLayerZero ] = NetworkDimension( p_clusterModel, netArch );
        
        if ~isempty(Temp_xy)
            %%% Clustering Phase
            [ p_clusterModel, noOfk, cluster, centr ] = Clustering( p_clusterModel, notLayerZero, Temp_xy, Temp_index, TH(a));
            recluster = false;
        end
    end
    
    % Each round check dead node
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        if  p_clusterModel.nodeArch.node(i).type == 'C'
            
        end
        p_clusterModel.nodeArch.node(i).type    = 'N'; 
        p_clusterModel.nodeArch.node(i).parent  = [];
        p_clusterModel.nodeArch.node(i).child   = 0;
    end
    
    %%% CH & RN Selection Phase
    [ p_clusterModel ] = CHRNselection( p_clusterModel, locAlive, p_clusterModel.numCluster, p_clusterModel.centr, netArch, E_th, delta, dth(b) );
    
    %%% Control Packet diss
    p_clusterModel = dissEnergyCtl_2(p_clusterModel, roundArch, netArch, 'proposed');
    p_clusterModel.recluster=false;

    % check dead node after c.p.diss
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
        
%             recluster = true; % have to exec new clustering phase 
%             p_clusterModel.recluster=true; % This is for dissEnergyCtl_2.m
        end
    end

    %%% Transmission Phase
    p_clusterModel = dissEnergyCM(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyCH(p_clusterModel, roundArch, netArch);
    p_clusterModel = dissEnergyRN(p_clusterModel, roundArch, netArch);
    
    % check dead node after tx.diss
    locAlive = find(~p_clusterModel.nodeArch.dead);
    for i = locAlive
        if p_clusterModel.nodeArch.node(i).energy <= 0
            p_clusterModel.nodeArch.node(i).type = 'D';
            p_clusterModel.nodeArch.dead(i) = 1;
            p_clusterModel.nodeArch.node(i).parent = []; 
            p_clusterModel.nodeArch.node(i).CID = []; 
            p_clusterModel.nodeArch.node(i).child = 0; 
        
%             recluster = true; % have to exec new clustering phase 
%             p_clusterModel.recluster=true;
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
    p_clusterModel.nodeArch.numNode = numAlive; % number of Alive nodes for PROCESS
    p_clusterModel.nodeArch.numAlive = numAlive; % number of Alive nodes for STATISTICS
    p_clusterModel.nodeArch.avgEnergy = avgEnergy; % averagy energy

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

end




%% STATISTICS
p_FND = 0; l_FND = 0; tl_FND = 0; h_FND = 0;
p_HND = 0; l_HND = 0; tl_HND = 0; h_HND = 0;
p_LND = 0; l_LND = 0; tl_LND = 0; h_LND = 0;
for i = 1:simulationTime
    p_FND = p_FND + xpar_proposed(i).FND;
    p_HND = p_HND + xpar_proposed(i).HND;
    p_LND = p_LND + xpar_proposed(i).LND;
end
p_FND = floor(p_FND / simulationTime);
p_HND = floor(p_HND / simulationTime);
p_LND = floor(p_LND / simulationTime);
p_clusterModel.avgFND = p_FND;
p_clusterModel.avgHND = p_HND;
p_clusterModel.avgLND = p_LND;

%tradeOff_FND(10-a,b) = p_FND;
%tradeOff_HND(10-a,b) = p_HND;
end
end

